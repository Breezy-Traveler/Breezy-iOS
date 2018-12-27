
import Foundation

protocol ThrottlerDelegate: class {
    func throttler(_ throttler: Throttler, didExecuteJobAt lastExecutionDate: Date?)
    
    /**
     when the timer has exceeded from last execution
     */
    func throttlerDidFinishCycle(_ throttler: Throttler)
}

class Throttler {
    
    var job: DispatchWorkItem!
    var isCanceled: Bool {
        return job.isCancelled
    }
    
    var maxInterval: Int
    
    private var cycleTimer: Timer?
    private var previousRun: Date? {
        didSet {
            self.cycleTimer?.invalidate()
            self.cycleTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(maxInterval), repeats: false, block: { (_) in
                self.delegate?.throttlerDidFinishCycle(self)
            })
        }
    }
    
    var queue: DispatchQueue
    
    weak var delegate: ThrottlerDelegate?
    
    init(maxInterval: Int, queue: DispatchQueue = DispatchQueue.main, delegate: ThrottlerDelegate?) {
        self.maxInterval = maxInterval
        self.queue = queue
        self.delegate = delegate
    }
    
    func invoke(block: @escaping () -> Void) {
        guard self.previousRun == nil else { return }
        
        self.job = DispatchWorkItem(block: {
            self.previousRun = Date()
            block()
        })
        
        job.notify(queue: queue) {
            self.delegate?.throttler(self, didExecuteJobAt: self.previousRun)
        }
         
        queue.async(execute: self.job)
    }
}

class PostThrottler: Throttler {
    
    private var firstInvoke: Date?
    
    override func invoke(block: @escaping () -> Void) {
        let delay: Int
        
        //is there a previous invoke scheduled?
        if let firstInvoke = self.firstInvoke {
            self.job.cancel()
            delay = self.maxInterval - Date.seconds(from: firstInvoke)
            
        //store the first invoke
        } else {
            delay = self.maxInterval
            self.firstInvoke = Date()
        }
        
        self.job = DispatchWorkItem(block: {
            self.firstInvoke = Date()
            block()
        })
        
        job.notify(queue: queue) {
            self.delegate?.throttler(self, didExecuteJobAt: self.firstInvoke)
        }
        
        self.queue.asyncAfter(deadline: .now() + Double(delay), execute: self.job)
    }
}

class ContinuousThrottler: Throttler {
    
    private var cycleTimer: Timer?
    private var mostRecentInvoke: Date? {
        didSet {
            self.cycleTimer?.invalidate()
            self.cycleTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(maxInterval), repeats: false, block: { (_) in
                self.delegate?.throttlerDidFinishCycle(self)
            })
        }
    }
    
    override func invoke(block: @escaping () -> Void) {
        if self.mostRecentInvoke != nil {
            self.job.cancel()
        }
        
        self.mostRecentInvoke = Date()
        let delay = self.maxInterval
        
        self.job = DispatchWorkItem(block: {
            block()
        })
        
        job.notify(queue: queue) {
            self.delegate?.throttler(self, didExecuteJobAt: self.mostRecentInvoke)
        }
        
        self.queue.asyncAfter(deadline: .now() + Double(delay), execute: self.job)
    }
}

class ThrottleSingleton: ThrottlerDelegate {
    static var shared = ThrottleSingleton()
    
    private var throttles: [String: Throttler] = [:]
    
    subscript(_ identifier: String) -> Throttler? {
        set {
            throttles[identifier] = newValue
        }
        get {
            return throttles[identifier]
        }
    }
    
    private init() { }
    
    // MARK: - RETURN VALUES
    
    // MARK: - VOID METHODS
    
    func throttler(_ throttler: Throttler, didExecuteJobAt lastExecutionDate: Date?) {
    }
    
    func throttlerDidFinishCycle(_ throttler: Throttler) {
        if let indexToRemove = throttles.index(where: { keyValuePair in keyValuePair.value === throttler }) {
            throttles.remove(at: indexToRemove)
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}

public func throttle(for seconds: Int, identifier: String = #function, block: @escaping () -> Void) {
    let manager = ThrottleSingleton.shared
    guard manager[identifier] == nil else { return }
    
    let throttler = Throttler(maxInterval: seconds, delegate: manager)
    manager[identifier] = throttler
    
    throttler.invoke(block: block)
}

public func postThrottle(for seconds: Int, identifier: String = #function, block: @escaping () -> Void) {
    let manager = ThrottleSingleton.shared
    
    let throttler: Throttler
    
    if let exisitingThrottler = manager[identifier] {
        throttler = exisitingThrottler
    } else {
        throttler = PostThrottler(maxInterval: seconds, delegate: manager)
        manager[identifier] = throttler
    }
    
    throttler.invoke(block: block)
}

public func continuousThrottle(for seconds: Int, identifier: String = #function, block: @escaping () -> Void) {
    let manager = ThrottleSingleton.shared
    
    let throttler: Throttler
    
    if let exisitingThrottler = manager[identifier] {
        throttler = exisitingThrottler
    } else {
        throttler = ContinuousThrottler(maxInterval: seconds, delegate: manager)
        manager[identifier] = throttler
    }
    
    throttler.invoke(block: block)
}

private extension Date {
    static func seconds(from referenceDate: Date) -> Int {
        return Int(Date().timeIntervalSince(referenceDate).rounded())
    }
}

