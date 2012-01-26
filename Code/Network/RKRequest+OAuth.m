//
//  RKRequest+OAuth.m
//  RestKit
//
//  Created by Michael Lawlor on 4/4/11.
//  Copyright 2011 Two Toasters. All rights reserved.
//

#import "RKRequest+OAuth.h"
#import "RKRequest.h"
#import "RKRequestQueue.h"
#import "RKResponse.h"
#import "NSDictionary+RKRequestSerialization.h"
#import "RKNotifications.h"
#import "RKClient.h"
#import "../Support/Support.h"
#import "RKURL.h"
#import "NSData+MD5.h"
#import "NSString+MD5.h"
#import "RKLog.h"
#import "RKRequestCache.h"
#import "TDOAuth.h"

@implementation RKRequest (OAuth)
    
@synthesize forceOAuth;
@synthesize oAuthConsumerKey;
@synthesize oAuthConsumerSecret;
@synthesize oAuthAccessToken;
@synthesize oAuthTokenSecret;


- (id)initWithURL:(NSURL*)URL {
    self = [super initWithURL:URL];
	if (self) {
        self.forceOAuth = NO;
	}
	return self;
}

- (void)dealloc {
    [self.oAuthConsumerKey release];
    self.oAuthConsumerKey = nil;
    [self.oAuthConsumerSecret release];
    self.oAuthConsumerSecret = nil;
    [self.oAuthAccessToken release];
    self.oAuthAccessToken = nil;
    [self.oAuthTokenSecret release];
    self.oAuthTokenSecret = nil;
    [super dealloc];
}

- (void)setOAuth:(BOOL)enabled consumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessToken:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret
{
    if(enabled && consumerKey != nil && consumerSecret != nil && accessToken != nil && tokenSecret != nil)
    {
        self.forceOAuth = YES;
        self.forceBasicAuthentication = NO; // oAuth can't be used in conjunction with Basic Auth
        self.oAuthConsumerKey = consumerKey;
        self.oAuthConsumerSecret = consumerSecret;
        self.oAuthAccessToken = accessToken;
        self.oAuthTokenSecret = tokenSecret;
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

- (BOOL)prepareURLRequest {
    if(!self.forceOAuth)
    {
        return [super prepareURLRequest];
    }

    TDOAuth *oauth = [[TDOAuth alloc] initWithConsumerKey:self.oAuthConsumerKey
                                           consumerSecret:self.oAuthConsumerSecret
                                              accessToken:self.oAuthAccessToken
                                              tokenSecret:self.oAuthTokenSecret
                                                      url:[_URL copy]
                                                   method:[[self HTTPMethod] copy]];
    if(self.params == nil)
    {
        self.params = [[RKParams alloc] initWithDictionary:[NSMutableDictionary dictionaryWithCapacity:5]];
    }
    if([self.params respondsToSelector:@selector(attachments)])
    {
        NSLog(@"Adding attachments as params:");
        RKParams *requestParams = (RKParams *)self.params;
        NSMutableDictionary *nonOauthParams = [[NSDictionary alloc] init];
        for(RKParamsAttachment *attachment in requestParams.attachments)
        {
            NSLog(@"%@ => %@", attachment.name, attachment.fileName);
            [nonOauthParams setValue:attachment.fileName forKey:attachment.name];
        }
        [oauth addParameters:nonOauthParams];
    } else {
        NSLog(@"couldn't add existing params, or no existing params present: %@", self.params);
    }
    if([self.params isKindOfClass:[RKParams class]])
    {
        NSLog(@"Adding oAuth params to request:");
        RKParams *sparams = (RKParams *)self.params;
        for(NSString *key in oauth.params.allKeys)
        {
            if([sparams respondsToSelector:@selector(setValue:forParam:)])
            {
                NSLog(@"%@ => %@", key, [oauth.params objectForKey:key]);
                [sparams setValue:[[oauth.params objectForKey:key] copy] forParam:key];
            }
        }
    }
    else
    {
        NSLog(@"Couldn't add oAuth params to request because params object is not compatible %@", [self.params class]);
    }
    NSURLRequest *tmpRequest = [oauth request];
    [_URLRequest setValue:[[tmpRequest valueForHTTPHeaderField:@"Authorization"] copy] forHTTPHeaderField:@"Authorization"];
    [_URLRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [self setRequestBody];
    [self addHeadersToRequest];
    NSString* body = [[NSString alloc] initWithData:[_URLRequest HTTPBody] encoding:NSUTF8StringEncoding];
    RKLogTrace(@"Prepared %@ URLRequest '%@'. HTTP Headers: %@. HTTP Body: %@.", [self HTTPMethod], _URLRequest, [_URLRequest allHTTPHeaderFields], body);
    [body release];
    
    return YES;
}

@end