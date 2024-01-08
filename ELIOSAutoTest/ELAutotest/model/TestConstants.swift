//
//  TestConstants.swift
//  ELIOSAutoTest
//
//  Created by jack on 09.12.2023.
//

import UIKit

class TestConstants: NSObject {
    static let runTestJson: String = """
{"forceLang":"en","testId":"1","testRunName":"12312","testRunId":"2a511c8c-90ac-449a-83a7-b52b438422a7","testCases":[{"rotation":0,"viewControllerStateDataJson":"{}",
"standardTestCaseDataId":1,"viewControllerName":"RootViewController","autotestStandardEventIds":"1;2;3;","autotestEvents":[{"point":"{227, 231.33333333333331}",
"autotestEventId":1,"delay":0,
"eventType":"click","windowIndex":0,
"rotation":1},{"point":"{227, 231.33333333333331}"
,"windowIndex":0,"eventType":"click",
"delay":0,"rotation":1,"autotestEventId":2},{"autotestEventId":3,
"eventType":"screenshot",
"delay":0,
"rotation":0,"windowIndex":0}],
"testCaseName":"tc1",
"applicationStateDataJson":"{\"ATStringSaver\" : \"abc\"}",
"hideBackButton":true}]}
"""
    
    static let runTestBase64Json = """
eyJ0ZXN0Q2FzZXMiOlt7ImF1dG90ZXN0U3RhbmRhcmRFdmVudElkcyI6IjE7MjszOyIsImF1dG90ZXN0RXZlbnRzIjpbeyJhdXRvdGVzdEV2ZW50SWQiOjEsInJvdGF0aW9uIjoxLCJldmVudFR5cGUiOiJjbGljayIsIndpbmRvd0luZGV4IjowLCJkZWxheSI6MCwicG9pbnQiOiJ7MjI3LCAyMzEuMzMzMzMzMzMzMzMzMzF9In0seyJwb2ludCI6InsyMjcsIDIzMS4zMzMzMzMzMzMzMzMzMX0iLCJhdXRvdGVzdEV2ZW50SWQiOjIsImV2ZW50VHlwZSI6ImNsaWNrIiwid2luZG93SW5kZXgiOjAsInJvdGF0aW9uIjoxLCJkZWxheSI6MH0seyJ3aW5kb3dJbmRleCI6MCwiYXV0b3Rlc3RFdmVudElkIjozLCJldmVudFR5cGUiOiJzY3JlZW5zaG90IiwiZGVsYXkiOjAsInJvdGF0aW9uIjowfV0sInJvdGF0aW9uIjowLCJ0ZXN0Q2FzZU5hbWUiOiJ0YzEiLCJzdGFuZGFyZFRlc3RDYXNlRGF0YUlkIjoxLCJ2aWV3Q29udHJvbGxlclN0YXRlRGF0YUpzb24iOiJ7XG5cbn0iLCJhcHBsaWNhdGlvblN0YXRlRGF0YUpzb24iOiJ7XG4gIFwiQVRTdHJpbmdTYXZlclwiIDogXCJ7XFxcInN0clxcXCI6XFxcInNvbWVTdHJpbmdcXFwifVwiLFxuICBcIkVtcGxveWVlc01hbmFnZXJcIiA6IFwie31cIlxufSIsImhpZGVCYWNrQnV0dG9uIjp0cnVlLCJ2aWV3Q29udHJvbGxlck5hbWUiOiJSb290Vmlld0NvbnRyb2xsZXIifV0sInRlc3RJZCI6IjEiLCJ0ZXN0UnVuSWQiOiI0ODc1MDkxMS1hZjI1LTQ0NzItYTAzMi05NmUyYzlhNzUzMzIiLCJ0ZXN0UnVuTmFtZSI6IjEyMzEyIiwiZm9yY2VMYW5nIjoiZW4ifQ==
"""
}
