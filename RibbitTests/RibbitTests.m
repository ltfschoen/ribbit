//
//  RibbitTests.m
//  RibbitTests
//
//  Created by Luke on 8/05/2014.
//  Copyright (c) 2014 Ceenos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImageViewController.h"
#import "CameraViewController.h"

@interface RibbitTests : XCTestCase

@property (nonatomic) CameraViewController *cameraViewController;
@property (nonatomic) ImageViewController *imageViewController;

@end

@implementation RibbitTests

- (void)setUp
{
    [super setUp];
    
    self.cameraViewController = [[CameraViewController alloc] init];
    self.imageViewController = [[ImageViewController alloc] init];
}

- (void)tearDown
{
    // add custom code before teardown
    self.cameraViewController = nil;
    self.imageViewController = nil;
    
    [super tearDown];
}

#pragma mark - Camera View Controller Test Cases

- (void) testCameraViewController
{
    // test if error with alloc and init of cameraViewController causing it to be nil
    XCTAssertNotNil(self.cameraViewController, @"cameraViewController model was nil");
}

- (void) testPropertiesNil
{
    // test if 'friendsRelation' property is nil
    XCTAssertNil(self.cameraViewController.friendsRelation, @"Friends Relation object of PFRelation in cameraViewController was not nil");
    
    // test if 'friends' property is nil
    XCTAssertNil(self.cameraViewController.friends, @"Friends array in cameraViewController was not nil");
    
    // test if 'recipients' property is nil
    XCTAssertNil(self.cameraViewController.recipients, @"Recipients mutable array in cameraViewController was not nil");
    
    // test if 'resizeImage' is not nil
    // pass random image called 'randomImage'
    UIImage *image;
    UIImage *randomImage = [self.cameraViewController resizeImage:(UIImage *)image toWidth:320.0f andHeight:480.0f];
    XCTAssertNotNil(randomImage, @"randomImage image in cameraViewController was nil");
}

- (void) testresizeImageIsUIImage {
    UIImage *image;
    id randomImage = [self.cameraViewController resizeImage:(UIImage *)image toWidth:320.0f andHeight:480.0f];
    // pass type of class if not UIImage class
    XCTAssertTrue([randomImage isKindOfClass:[UIImage class]], @"randomImage is of class '%@'", [randomImage class]);
}

#pragma mark - Image View Controller Test Cases

- (void) testImageViewController
{
    // test if error with alloc and init of imageViewController causing it to be nil
    XCTAssertNotNil(self.imageViewController, @"imageViewController model was nil");
}

- (void) testMessagePropertyNil
{
    // test if 'message' property is nil
    XCTAssertNil(self.imageViewController.message, @"Message object of imageViewController was not nil");
}

#pragma mark - Practice Simple Unrelated Test Cases

- (void) testTrue
{
    // parameters include expression and formatted string
    XCTAssertTrue(true, @"Expression was not true");
}

- (void) testFalse
{
    int val1 = 1;
    int val2 = 2; // passes
//    int val2 = 1; // fails
    // both values passed as parameters
    XCTAssertFalse(val1 == val2, @"%d == %d should evaluate to false",val1,val2);
}

#pragma mark - Practice Simple Object Test Cases

- (void) testStringForNil
{
    // create instance of an object as string literal without alloc and init
    // check if it is nil
    
    NSString *someString; // passes
//    NSString *someString = @"workshop"; // fails
    XCTAssertNil(someString, @"someString was not nil");
}

- (void) testStringNotNil
{
    // create instance of an object as string literal without alloc and init
    // check if it is not nil
    
//    NSString *someString; // passes
    NSString *someString = @"workshop"; // fails
    XCTAssertNotNil(someString, @"someString == '%@'",someString);
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
