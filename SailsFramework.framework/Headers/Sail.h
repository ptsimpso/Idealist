//
//  Sail.h
//  SailTest
//
//  Created by Peter Simpson on 2/19/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sail : NSObject
+ (instancetype)sharedInstance;
- (void)startSessionWithKey:(NSString *)key andLaunchOptions:(NSDictionary *)launchOptions;
- (void)setAnonymousUserWithCompletion:(void (^)(NSDictionary *userParams, BOOL wasJustReferred))block;
- (void)setUser:(NSString *)uid withCompletion:(void (^)(NSDictionary *userParams, BOOL wasJustReferred))block;
- (void)getUserData:(void (^)(NSDictionary *userParams))block;
- (void)clearUser;
- (void)listenForNewReferralsWithResponse:(void (^)(NSDictionary *userParams))block;
- (void)listenForNewPrizeWithResponse:(void (^)(NSDictionary *userParams))block;
@end
