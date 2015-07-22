package com.github.rahulsom.ios

import io.appium.java_client.ios.IOSDriver
import org.junit.Rule
import org.junit.rules.TestName
import org.openqa.selenium.OutputType
import org.openqa.selenium.WebDriverException
import org.openqa.selenium.remote.CapabilityType
import org.openqa.selenium.remote.DesiredCapabilities
import spock.lang.Specification
import spock.util.concurrent.PollingConditions

/**
 * Base class for specs in this app. It initializes the app and allows you to run your tests against it.
 *
 * @author Rahul Somasunderam
 */
abstract class AbstractSpec extends Specification implements EnhancedAppium {

    @Rule
    TestName name = new TestName()
    int snapshotIndex = 0

    def setup() {
        GroovifyAppium.init()
        File appDir = new File("../build/sym/Debug-iphonesimulator/")
        File app = new File(appDir, "Todos.app")
        DesiredCapabilities capabilities = new DesiredCapabilities()
        capabilities.setCapability(CapabilityType.BROWSER_NAME, "")
        capabilities.setCapability("platformName", "iOS")
        capabilities.setCapability("deviceName", "iPhone 6")
        capabilities.setCapability("app", app.absolutePath)
        driver = new IOSDriver(new URL("http://127.0.0.1:4723/wd/hub"), capabilities)
        snapshotIndex = 0

        if (this.metaClass.methods.find { it.name == 'postSetup' }) {
            this.postSetup()
        }
    }

    void takeSnapshot() {
        if (System.getenv('JENKINS_URL')) {
            println "Running on jenkins. Will not snapshot."
            return
        }
        int currIndex = snapshotIndex++

        def snapshotDir = 'build/snapshots'
        if (!new File(snapshotDir).exists()) {
            new File(snapshotDir).mkdirs()
        }

        def methodName = name.methodName.replace(' ', '-')
        def className = this.class.name
        def snapshotName = "${className}.${methodName}-${currIndex}"

        Profiler.profile("takeSnapshot('$snapshotName')") {
            def xmlFile = new File("${snapshotDir}/${snapshotName}.xml")
            xmlFile.text = driver.pageSource
            println "[[ATTACHMENT|${xmlFile.absolutePath}]]"

            def base64 = driver.getScreenshotAs(OutputType.BASE64)
            def bytes = base64.decodeBase64()

            def pngFile = new File("${snapshotDir}/${snapshotName}.png")
            if (pngFile.exists()) {
                pngFile.delete()
            }
            def str = pngFile.newOutputStream()
            str.write(bytes)
            println "[[ATTACHMENT|${pngFile.absolutePath}]]"
        }

    }

    def cleanup() {
        try {
            takeSnapshot()
        } catch (WebDriverException e) {
            println "Error obtaining snapshot"
            e.printStackTrace(System.err)
        } finally {
            driver.quit()
        }
    }

}
