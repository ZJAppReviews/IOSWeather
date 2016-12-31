//
//  Weather.h
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property(nonatomic,assign) int cityId;
@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,strong) NSString *week;
@property(nonatomic,strong) NSString *date_y;
@property(nonatomic,strong) NSString *pm;
@property(nonatomic,strong) NSString *pmLevel;
@property(nonatomic,strong) NSString *weather;
@property(nonatomic,strong) NSString *temp;
@property(nonatomic,strong) NSString *wind;
@property(nonatomic,strong) NSString *windLevel;


//保存未来的天气
@property(nonatomic,strong) NSMutableArray *futureWeatherArray;

-(instancetype)initWithWeatherData:(NSData *)weatherData;
@end
