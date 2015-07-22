package com.github.rahulsom.todos

import com.github.rahulsom.ios.AbstractSpec
import spock.util.concurrent.PollingConditions

class TodosSpec extends AbstractSpec {

    def "the initial page looks ok"() {
        given: "The app is launched"

        when: "You inspect all buttons"
        def buttons = C("UIAButton")

        then: "A button is present for login and settings"
        buttons.size() == 3
        buttons*.text == ['Clear Done', 'Back', 'Add']

        when: "You inspect all todos"
        def rows = C("UIATableCell")

        then: "There is 3 todos present"
        rows.size() == 3
        E('.UIATableCell .UIAStaticText')*.text == ["Let's get started", 'This is a TODO', "And here's one more"]
        E('.UIATableCell .UIASwitch')*.value() == ['0', '0', '1']

    }

    def "clicking 'clear done' removes 'done' tasks"() {
        given: "The app is launched"
        def c = new PollingConditions(timeout: 60, initialDelay: 1, delay: 2, factor: 1.25)

        when: "You inspect all buttons"
        def buttons = C("UIAButton")

        then: "A button is present for login and settings"
        buttons.size() == 3
        buttons*.text == ['Clear Done', 'Back', 'Add']

        when: "You inspect all todos"
        def rows = C("UIATableCell")

        then: "There is 3 todos present"
        rows.size() == 3
        E('.UIATableCell .UIAStaticText')*.text == ["Let's get started", 'This is a TODO', "And here's one more"]
        E('.UIATableCell .UIASwitch')*.value() == ['0', '0', '1']

        when: "You click 'Clear Done'"
        buttons.find { it.text == 'Clear Done' }.click()

        then: "The rows drop to 2"
        c.eventually {
            assert C("UIATableCell").size() == 2
        }

    }

    def "can add tasks"() {
        given: "The app is launched"
        def c = new PollingConditions(timeout: 60, initialDelay: 1, delay: 2, factor: 1.25)

        when: "You inspect all buttons"
        def buttons = C("UIAButton")

        then: "A button is present for login and settings"
        buttons.size() == 3
        buttons*.text == ['Clear Done', 'Back', 'Add']

        when: "You inspect all todos"
        def rows = C("UIATableCell")

        then: "There is 3 todos present"
        rows.size() == 3
        E('.UIATableCell .UIAStaticText')*.text == ["Let's get started", 'This is a TODO', "And here's one more"]
        E('.UIATableCell .UIASwitch')*.value() == ['0', '0', '1']

        when: "You click 'Add'"
        buttons.find { it.text == 'Add' }.click()

        then: "The Add Task page shows up"
        c.eventually {
            assert C("UIAButton").find { it.text == 'Save' }
        }

        when: "I enter new text and save"
        C('UIATextField')[0].value = 'This is new'
        C("UIAButton").find { it.text == 'Save' }.click()
        c = new PollingConditions(timeout: 60, initialDelay: 1, delay: 2, factor: 1.25)

        then: "The rows is now 4"
        C('UIATableView').findAll {it.text == 'This is new'}.size() == 4
        c.eventually {
            assert C("UIATableCell").size() == 4
        }

    }

}
