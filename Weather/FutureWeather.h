//
//  FutureWeather.h
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FutureWeather : NSObject
@property(nonatomic,strong) NSString *temp;
@property(nonatomic,strong) NSString *weather;
@property(nonatomic,strong) NSString *wind;
@property(nonatomic,strong) NSString *week;

- (instancetype)initWithWeather:(NSString *)weather
                           temp:(NSString *)temp
                           wind:(NSString *)wind
                           week:(NSString *)week;

@end
