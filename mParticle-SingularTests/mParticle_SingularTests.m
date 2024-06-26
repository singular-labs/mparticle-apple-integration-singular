//
//  mParticle_SingularTests.m
//  mParticle-SingularTests
//
//  Created by Ben Baron on 4/12/24.
//

#import <XCTest/XCTest.h>

@import mParticle_Singular;

#define API_KEY @"apiKey"
#define SECRET_KEY @"secret"
#define DDL_TIMEOUT @"ddlTimeout"

#define SDK_KEY @"realprodcorp1"
#define SDK_SECRET @"d38bfbce70b42a70fe920f425e73d123"

@interface mParticle_SingularTests : XCTestCase
@property (nonatomic, strong, nullable) MPKitSingular * singularKit;
@end

@implementation mParticle_SingularTests

- (void)setUp {
   _singularKit = [[MPKitSingular alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testValidConfiguration {
    NSMutableDictionary * config = [[NSMutableDictionary alloc] init];
    
    [config setObject:SDK_KEY forKey:API_KEY];
    [config setObject:SDK_SECRET forKey:SECRET_KEY];
    
    MPKitExecStatus * execResult = [_singularKit didFinishLaunchingWithConfiguration:config];
    
    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testInvalidConfiguration {
    NSMutableDictionary * config = [[NSMutableDictionary alloc] init];

    MPKitExecStatus * execResult = [_singularKit didFinishLaunchingWithConfiguration:config];
    
    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeRequirementsNotMet);
}

- (void)testLogEventWithoutInfo {

    [self testValidConfiguration];

    MPEvent * event = [[MPEvent alloc] initWithName:@"Test Event" type:MPEventTypeOther];

    MPKitExecStatus * execResult = [_singularKit logBaseEvent:event];

    [NSThread sleepForTimeInterval:2];

    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventWithInfo {

    NSMutableDictionary * config = [[NSMutableDictionary alloc] init];

    [config setObject:SDK_KEY forKey:API_KEY];
    [config setObject:SDK_SECRET forKey:SECRET_KEY];

    MPKitExecStatus * execResult = [_singularKit didFinishLaunchingWithConfiguration:config];

    MPEvent * event = [[MPEvent alloc] initWithName:@"Test Event" type:MPEventTypeOther];

    NSDictionary<NSString*,id> * eventInfo = [[NSMutableDictionary alloc] init];

    [eventInfo setValue:@"True" forKey:@"Testing"];
    [event setCustomAttributes:eventInfo];

    execResult = [_singularKit logBaseEvent:event];

    [NSThread sleepForTimeInterval:2];

    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogCommerceEventWithProducts {

    NSMutableDictionary * config = [[NSMutableDictionary alloc] init];

    [config setObject:SDK_KEY forKey:API_KEY];
    [config setObject:SDK_SECRET forKey:SECRET_KEY];

    MPKitExecStatus * execResult = [_singularKit didFinishLaunchingWithConfiguration:config];

    MPProduct * product = [[MPProduct alloc] initWithName:@"Very Nice!"
                                                      sku:@"12345"
                                                 quantity:[NSNumber numberWithDouble:5.0]
                                                    price:[NSNumber numberWithDouble:5.0]];

    MPCommerceEvent * event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionPurchase
                                                              product:product];

    execResult = [_singularKit logBaseEvent:event];

    [NSThread sleepForTimeInterval:2];

    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogCommerceEventWithInstructions {

    NSMutableDictionary * config = [[NSMutableDictionary alloc] init];

    [config setObject:SDK_KEY forKey:API_KEY];
    [config setObject:SDK_SECRET forKey:SECRET_KEY];

    MPKitExecStatus * execResult = [_singularKit didFinishLaunchingWithConfiguration:config];

    MPProduct * product = [[MPProduct alloc] initWithName:@"Very Nice!"
                                                      sku:@"12345"
                                                 quantity:[NSNumber numberWithDouble:5.0]
                                                    price:[NSNumber numberWithDouble:5.0]];

    MPCommerceEvent * event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionViewDetail
                                                              product:product];

    execResult = [_singularKit logBaseEvent:event];

    [NSThread sleepForTimeInterval:2];

    XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

@end
