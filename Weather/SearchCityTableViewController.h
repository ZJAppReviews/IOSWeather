//
//  SearchCityTableViewController.h
//  Weather
//
//  Created by F&Easy on 16/10/12.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCityTableViewController : UITableViewController

//定义block类型的成员变量 completeBackHander 变量名  cityCode参数 void返回值为空

@property(copy) void(^completeBackHander)(int cityCode);

@end
