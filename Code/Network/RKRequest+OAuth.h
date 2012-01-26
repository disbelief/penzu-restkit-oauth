//
//  RKRequest+OAuth.h
//  RestKit
//
//  Created by Michael Lawlor on 4/4/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKRequest.h"

@interface RKRequest (OAuth) 
/*{
    BOOL _forceOAuth;
    NSString* _oAuthConsumerKey;
    NSString* _oAuthConsumerSecret;
    NSString* _oAuthAccessToken;
    NSString* _oAuthTokenSecret;
}*/

/**
 * When enabled, requests sent out will be setup as oAuth requests
 * not to be used in conjunction with HTTP authentication.
 */
@property (nonatomic, assign) BOOL forceOAuth;

/**
 * The credentials to be used for oAuth requests
 */
@property (nonatomic, retain) NSString* oAuthConsumerKey;
@property (nonatomic, retain) NSString* oAuthConsumerSecret;
@property (nonatomic, retain) NSString* oAuthAccessToken;
@property (nonatomic, retain) NSString* oAuthTokenSecret;

/**
 * Enables or disabled oAuth for the request.
 * if disabling, only the enabled param is necessary.
 * If enabling, all params are required.
 * Note: enabling oAuth automatically disables basic HTTP 
 * authentication for the request.
 */
- (void)setOAuth:(BOOL)enabled consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;

@end