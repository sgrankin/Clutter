//
//  ClutterTests.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(UISegmentedControlSpec)

describe(@"UISegmentedControl", ^{
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"segment 0", @"segment 1"]];
    beforeAll(^{
    });
    
    it(@"titleForSelectedSegment works", ^{
        control.selectedSegmentIndex = 0;
        [[control.titleForSelectedSegment should] equal:@"segment 0"];
        
        control.selectedSegmentIndex = 1;
        [[control.titleForSelectedSegment should] equal:@"segment 1"];
    });
    
    it(@"segmentIndexForTitle works", ^{
        control.selectedSegmentIndex = 0;
        [[@([control segmentIndexForTitle:@"segment 0"]) should] equal:@0];
        [[@([control segmentIndexForTitle:@"segment 1"]) should] equal:@1];
        [[@([control segmentIndexForTitle:@"segment banana"]) should] equal:@-1];
    });

    it(@"selectSegemntWithTitle works", ^{
        control.selectedSegmentIndex = -1;
        
        [control selectSegmentWithTitle:@"segment 0"];
        [[@(control.selectedSegmentIndex) should] equal:@0];
        
        [control selectSegmentWithTitle:@"segment 1"];
        [[@(control.selectedSegmentIndex) should] equal:@1];

        [control selectSegmentWithTitle:@"segment banana"];
        [[@(control.selectedSegmentIndex) should] equal:@-1];
    });
});

SPEC_END