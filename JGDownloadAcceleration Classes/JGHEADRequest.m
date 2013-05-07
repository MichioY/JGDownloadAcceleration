//
//  JGHEADRequest.m
//  JGDownloadAccelerator Tester
//
//  Created by Jonas Gessner on 05.05.13.
//  Copyright (c) 2013 Jonas Gessner. All rights reserved.
//

#import "JGHEADRequest.h"

@implementation JGHEADRequest

@synthesize delegate;

#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)__unused connection didFailWithError:(NSError *)error {
    [delegate didRecieveResponse:nil error:error];
}

- (void)connection:(NSURLConnection *)__unused connection didReceiveResponse:(NSURLResponse *)response {
    [self cancel];
    [delegate didRecieveResponse:(NSHTTPURLResponse *)response error:nil];
}

#pragma mark - Handle Connection

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        NSParameterAssert(url != nil);
        
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:url];
        [newRequest setValue:USER_AGENT forHTTPHeaderField:@"User-Agent"];
        
        [newRequest setHTTPMethod:@"HEAD"];
        
        headerConnection = [[NSURLConnection alloc] initWithRequest:newRequest delegate:self startImmediately:NO];
    }
    return self;
}

- (void)start {
    //requires runloop, method has to be called on netowrk thread
    [headerConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [headerConnection start];
}

- (void)cancel {
    //method has to be called on netowrk thread
    [headerConnection cancel];
}

@end