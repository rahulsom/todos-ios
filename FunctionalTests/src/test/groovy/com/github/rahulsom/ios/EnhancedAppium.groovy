package com.github.rahulsom.ios

import groovy.transform.CompileStatic
import io.appium.java_client.AppiumDriver
import io.appium.java_client.MobileBy
import io.appium.java_client.MobileElement
import org.openqa.selenium.By
import org.openqa.selenium.SearchContext

/**
 * Enhances Appium's Driver with the ability to find by Accessibility Ids, Element Class and Patterns comprising the
 * two.
 *
 * @author Rahul Somasunderam
 */
@CompileStatic
trait EnhancedAppium {
    AppiumDriver driver

    /**
     * Find by Accessibility Id
     *
     * @param accessibilityId Accessibility Id of element
     * @return
     */
    List<MobileElement> A(String accessibilityId) {
        Profiler.profile("A('$accessibilityId')") {
            driver.findElementsByAccessibilityId(accessibilityId)
        } as List<MobileElement>
    }

    /**
     * Find by class name
     * @param className class name beginning with UIA
     * @return
     * @deprecated Use Accessibility Id if possible Otherwise use nested selectors with Enhanced Selectors. Class
     * selectors are known to have terrible performance. The performance woes are not inherent to the selector, but
     * because once you get the results of the selector, calling code is likely to iterate over the results, and run
     * checks on properties like name or value, which fire commands on Appium.
     */
    @Deprecated
    List<MobileElement> C(String className) {
        Profiler.profile("C('$className')") {
            driver.findElementsByClassName(className)
        } as List<MobileElement>
    }

    /**
     * Find by enhanced selectors
     *
     * @param selector jQuery like selector
     * @return
     */
    List<MobileElement> E(String selector) {
        Profiler.profile("E('$selector')") {
            selector.split(' ').inject([driver] as List<SearchContext>) { List<SearchContext> elems, String path ->
                By by
                if (path.startsWith('#')) {
                    by = MobileBy.AccessibilityId(path[1..-1])
                } else if (path.startsWith('.')) {
                    by = MobileBy.className(path[1..-1])
                } else {
                    throw new Exception("bad path: $path")
                }

                elems.collect { SearchContext elem -> elem.findElements(by) }.flatten()

            } as List<MobileElement>
        }
    }

}
