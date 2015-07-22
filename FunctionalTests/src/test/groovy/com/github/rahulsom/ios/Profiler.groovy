package com.github.rahulsom.ios

import org.codehaus.groovy.runtime.StackTraceUtils

/**
 * Poor mans profiler for performance of selectors and improving test/application design
 *
 * @author Rahul Somasunderam
 */
class Profiler {
    static final MaxTime = 1000
    static final MaxElements = 8
    public static final String[] ALL_PACKAGES = StackTraceUtils.GROOVY_PACKAGES +
            ['org.spockframework', 'org.junit', 'org.gradle']

    static <T> T profile(String methodCall, Closure<T> closure) {
        def start = System.nanoTime()
        def startTime = new Date()
        def retVal = closure.call()
        def finish = System.nanoTime()
        def finishTime = new Date()
        def format = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        def trace = Thread.currentThread().stackTrace.
                findAll { StackTraceElement traceElement ->
                    !ALL_PACKAGES.any { pkg -> traceElement.className.startsWith(pkg) } &&
                            traceElement.lineNumber > 0 &&
                            traceElement.fileName &&
                            traceElement.className != Profiler.canonicalName
                }.
                collect {
                    "${it.className}.${it.methodName}() (${it.fileName}:${it.lineNumber})"
                }.
                join('\r')


        def duration = (finish - start) / 1E6
        def collectionSize = retVal instanceof Collection ? retVal.size() : -1

        if (duration > MaxTime || collectionSize > MaxElements) {
            def data = [
                    startTime.format(format),
                    finishTime.format(format),
                    methodCall,
                    Math.round(duration),
                    collectionSize,
                    trace
            ]
            new File('build/timing.csv').append(data.collect { "\"$it\"" }.join(',') + "\n")
        }
        retVal
    }
}
