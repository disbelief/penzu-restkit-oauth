//
//  RKClient+OAuth.m
//  RestKit
//
//  Created by Michael Lawlor on 4/4/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKClient+OAuth.h"

@implementation RKClient (OAuth)

@synthesize forceOAuth;
@synthesize oAuthConsumerKey;
@synthesize oAuthConsumerSecret;
@synthesize oAuthAccessToken;
@synthesize oAuthTokenSecret;


- (void)setOAuth:(BOOL)enabled consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    //NSLog(@"RKClient.setOAuth %@ %@ %@ %@ %@", enabled, consumerKey, consumerSecret, accessToken, tokenSecret);
    if(enabled && consumerKey != nil && consumerSecret != nil && accessToken != nil && tokenSecret != nil)
    {
        self.forceOAuth = YES;
        self.forceBasicAuthentication = NO; // oAuth can't be used in conjunction with Basic Auth
        self.oAuthConsumerKey = [consumerKey copy];
        self.oAuthConsumerSecret = [consumerSecret copy];
        self.oAuthAccessToken = [accessToken copy];
        self.oAuthTokenSecret = [tokenSecret copy];
    }
    else 
    {
        self.forceOAuth = NO;
        self.oAuthConsumerKey = nil;
        self.oAuthConsumerSecret = nil;
        self.oAuthAccessToken = nil;
        self.oAuthTokenSecret = nil;        
    }
}

- (void)setupRequest:(RKRequest*)request
{
    [super setupRequest:request];
    if(self.forceOAuth)
    {
        [request setOAuth:YES consumerKey:self.oAuthConsumerKey consumerSecret:self.oAuthConsumerSecret accessToken:self.oAuthAccessToken tokenSecret:self.oAuthTokenSecret];
    }
}


@end