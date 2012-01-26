//
//  RKClient+OAuth.h
//  RestKit
//
//  Created by Michael Lawlor on 4/4/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKClient.h"


@interface RKClient (OAuth) 
/*{

    BOOL _forceOAuth;
    NSString* _oAuthConsumerKey;
    NSString* _oAuthConsumerSecret;
    NSString* _oAuthAccessToken;
    NSString* _oAuthTokenSecret;
    
}

static char _forceOAuthKey;
objc_setAssociatedObject(RKClient, &_forceOAuthKey, NO, OBJC_ASSOCIATION_ASSIGN);
 */

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

- (void)setOAuth:(BOOL)enabled consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret;

@end