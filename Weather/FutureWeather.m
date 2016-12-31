//
//  FutureWeather.m
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "FutureWeather.h"

@implementation FutureWeather

- (instancetype)initWithWeather:(NSString *)weather
                           temp:(NSString *)temp
                           wind:(NSString *)wind
                           week:(NSString *)week
{
    self = [super init];
    if (self) {
        self.weather = weather;
        self.week = week;
        self.wind = wind;
        self.temp = temp;
    }
    return self;
}

@end
