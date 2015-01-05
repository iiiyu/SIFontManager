//
//  SIFontsDataModelTest.m
//  SIFontManager
//
//  Created by Xiao ChenYu on 12/13/14.
//  Copyright (c) 2014 Xiao ChenYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FontsDataModel.h>

@interface SIFontsDataModelTest : XCTestCase

@property (nonatomic, strong) FontsDataModel *dataModel;

@end

@implementation SIFontsDataModelTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dataModel = [[FontsDataModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSectionCount
{
    XCTAssertTrue([self.dataModel sectionCount] > 0);
}

//- (void)testExample {
//    // This is an example of a functional test case.
//    XCTAssert(YES, @"Pass");
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
