//
//  TestNSURLRequest.m
//  ClutterTests
//
//  Created by Sergey Grankin on 5/31/12.
//  Copyright (c) 2012 Lobster Dynamics. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(NSURLRequestSpec)

describe(@"NSURLRequest", ^{
    describe(@"-description", ^{
        it(@"describes a url", ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            [[request.description should] equal:@"curl -X GET \"http://example.com\""];
        });
    });
});

describe(@"NSMutableURLRequest", ^{
    describe(@"-description", ^{
        it(@"described a url with headers", ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://example.com"]];
            [request addValue:@"banana" forHTTPHeaderField:@"Banana"];
            [[request.description should] equal:@"curl -X GET -H \"Banana: banana\" \"http://example.com\""];
        });
    });
});

SPEC_END