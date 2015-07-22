package com.github.rahulsom.ios

import io.appium.java_client.MobileElement

/**
 * Groovifies appium by adding name, value and << operations
 *
 * @author Rahul Somasunderam
 */
class GroovifyAppium {
    private static boolean initialized = false

    static init() {
        if (!initialized) {
            initialized = true
            MobileElement.metaClass.value = { ->
                ((MobileElement) delegate).getAttribute('value')
            }
            MobileElement.metaClass.name = { ->
                ((MobileElement) delegate).getAttribute('name')
            }
            MobileElement.metaClass.leftShift = { String s ->
                ((MobileElement) delegate).sendKeys(s)
            }
        }
    }
}
