//
//  ShowWeatherViewController.m
//  Weather
//
//  Created by F&Easy on 16/10/11.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "ShowWeatherViewController.h"
#import "Weather.h"
#import "FutureWeather.h"
#import "MBProgressHUD.h"
#import "SearchCityTableViewController.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define CENTERHORIZONTAL(WIDTH) (([UIScreen mainScreen].bounds.size.width - WIDTH)/2)
#define FUTUREVIEWCENTERHORIZONTAL(WIDTH) ((130 - WIDTH)/2)
#define TEXTFONTMIDDLE 25
#define TEXTFONTBIG 40
#define TEXTFONTNOMAL 20
#define TEXTFONTSMALL 18

#define ORGINY 64


#define PADDINGY 5


#define FUTUREWEATHERWIDTH 130

/**
 新建一个内部类，来自定义未来的天气
 */
//.h
@interface FutureWeatherView : UIView

@property(nonatomic,strong)FutureWeather *futureWeather;


@property(nonatomic,strong)UILabel *weekLabel;
@property(nonatomic,strong)UILabel *weatherLabel;
@property(nonatomic,strong)UILabel *tempLabel;
@end
//.m
@implementation FutureWeatherView

//封装自定义控件，从构造方法开始
//通过未来天气创建未来天气视图
- (instancetype)initWithFutureWeather:(FutureWeather *)futureWeather
{
    self = [super init];
    if (self) {
        self.futureWeather = futureWeather;
       //添加控件
        [self addSubviews];
        //计算FutureWeatherView的尺寸
        [self countViewSize];
    }
    return self;
}

-(void)countViewSize{
    CGFloat viewWidth = FUTUREWEATHERWIDTH;
    CGFloat viewHeight = _tempLabel.frame.origin.y + _tempLabel.frame.size.height +PADDINGY;
    self.frame = CGRectMake(0, 0, viewWidth, viewHeight);
}
-(void)addSubviews{
    [self addSubview: self.weekLabel];
    [self addSubview: self.weatherLabel];
    [self addSubview: self.tempLabel];
}



//懒加载模式： 对于类的成员变量，只需要写成员变量的get方法，当用到该变量时，会自动调用Get方法

/**
 Get方法

 @return _weekLabel
 */
-(UILabel *)weekLabel{
    if (_weekLabel) {
        return _weekLabel;
    }
    self.weekLabel = [[UILabel alloc]init];
    CGSize weekSize = [self countTextSizeWithText:_futureWeather.week textSize:TEXTFONTNOMAL];
    CGFloat weekLabelOrginX = FUTUREVIEWCENTERHORIZONTAL(weekSize.width);
    CGFloat weekLabelOrginY = 0;
    CGFloat weekLabelWidth = weekSize.width;
    CGFloat weekLabelHeight = weekSize.height;
    self.weekLabel.frame = CGRectMake(weekLabelOrginX, weekLabelOrginY, weekLabelWidth, weekLabelHeight);
    self.weekLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    self.weekLabel.text = _futureWeather.week;
    self.weekLabel.textColor = [UIColor whiteColor];
    
    return _weekLabel;
}


/**
 Get方法

 @return ——weatherLabel
 */
-(UILabel *)weatherLabel{
    if (_weatherLabel) {
        return _weatherLabel;
    }
    self.weatherLabel = [[UILabel alloc]init];
    CGSize weatherSize = [self countTextSizeWithText:_futureWeather.weather textSize:TEXTFONTNOMAL];
    CGFloat weatherLabelOrginX = FUTUREVIEWCENTERHORIZONTAL(weatherSize.width);
    CGFloat weatherLabelOrginY = _weekLabel.frame.origin.y + _weekLabel.frame.size.height;
    CGFloat weatherLabelWidth = weatherSize.width;
    CGFloat weatherLabelHeight = weatherSize.height;
    
    self.weatherLabel.frame = CGRectMake(weatherLabelOrginX, weatherLabelOrginY, weatherLabelWidth, weatherLabelHeight);
    self.weatherLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    self.weatherLabel.text = _futureWeather.weather;
    self.weatherLabel.textColor = [UIColor whiteColor];
    
    return _weatherLabel;
}


-(UILabel *)tempLabel{
    if (_tempLabel) {
        return _tempLabel;
    }
    self.tempLabel = [[UILabel alloc]init];
    CGSize tempSize = [self countTextSizeWithText:_futureWeather.temp textSize:TEXTFONTNOMAL];
    CGFloat tempLabelOrginX = FUTUREVIEWCENTERHORIZONTAL(tempSize.width);
    CGFloat tempLabelOrginY = _weatherLabel.frame.origin.y +_weatherLabel.frame.size.height;
    CGFloat tempLabelWidth = tempSize.width;
    CGFloat tempLabelHeight = tempSize.height;
    
    self.tempLabel.frame = CGRectMake(tempLabelOrginX, tempLabelOrginY, tempLabelWidth, tempLabelHeight);
    self.tempLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    self.tempLabel.text = _futureWeather.temp;
    self.tempLabel.textColor = [UIColor whiteColor];
    
    return _tempLabel;
}
-(CGSize)countTextSizeWithText:(NSString *)text textSize:(int)textFont{
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:textFont],
                                    };
    
    
    
    /**
     arg1：规定计算文字宽高范围 arg2：计算时的参考，参考字体大小和间距
     arg3：对文字描述用于计算文字尺寸
     arg4：一般为空
     
     kScreenWidth  宽度
     kScreenHeight 高度
     
     */
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight)
                                         options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                      attributes:attributeDict
                                         context:nil].size;
    return textSize;
    
}


@end

@interface ShowWeatherViewController ()

@property(nonatomic,strong)Weather *weather;


@property(nonatomic,assign)int cityId;

@property(nonatomic,strong)UILabel *cityNameLabel;
@property(nonatomic,strong)UILabel *pmLabel;
@property(nonatomic,strong)UILabel *netWorkErrorLabel;
@property(nonatomic,strong)UILabel *tempLabel;
@property(nonatomic,strong)UILabel *weatherLabel;
@property(nonatomic,strong)UILabel *dateLabel;
//颜色指示条
@property(nonatomic,strong)UIView *pmColorView;

//未来几天的滚动视图
@property(nonatomic,strong)UIScrollView *futureWeatherScroller;


@end

@implementation ShowWeatherViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //在当前页面的layer层添加背景
    UIImage *backGroundImage = [UIImage imageNamed:@"background"];
    self.view.layer.contents = (id)backGroundImage.CGImage;
    //设置标题
    self.navigationItem.title = @"天气预报";
    
    //添加左右按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    
    self.cityId =  101010100;
    
    [self getWeatherDataFromNetWork];
    [self addSubviews];
    
    
    
}

-(void)addSubviews{
    
    self.cityNameLabel = [[UILabel alloc]init];
    self.cityNameLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.font = [UIFont systemFontOfSize:TEXTFONTMIDDLE];
    self.cityNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_cityNameLabel];
    
    self.pmLabel = [[UILabel alloc]init];
    self.pmLabel.textColor = [UIColor whiteColor];
    self.pmLabel.font = [UIFont systemFontOfSize:TEXTFONTSMALL];
    self.pmLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_pmLabel];
    
    self.netWorkErrorLabel = [[UILabel alloc]init];
    self.netWorkErrorLabel.textColor = [UIColor blueColor];
    self.netWorkErrorLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    [self.view addSubview:_netWorkErrorLabel];
    
    self.weatherLabel = [[UILabel alloc]init];
    self.weatherLabel.textColor = [UIColor whiteColor];
    self.weatherLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    [self.view addSubview:_weatherLabel];
    
    self.tempLabel = [[UILabel alloc]init];
    self.tempLabel.textColor = [UIColor whiteColor];
    self.tempLabel.font = [UIFont systemFontOfSize:TEXTFONTBIG];
    [self.view addSubview:_tempLabel];
    
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:TEXTFONTNOMAL];
    [self.view addSubview:_dateLabel];
    
    self.pmColorView = [[UIView alloc]init];
    [self.view addSubview:_pmColorView];
  
    
    self.futureWeatherScroller = [[UIScrollView alloc]init];
    [self.view addSubview:_futureWeatherScroller];
    
  
}

-(void)reloadData{
    //确定控件的位置尺寸，和要显示的数据（布局）
    CGSize cityNameSize = [self countTextSizeWithText:_weather.cityName textSize:TEXTFONTMIDDLE];
    CGFloat cityNameLabelOrginX = (kScreenWidth - cityNameSize.width)/2;
    CGFloat cityNameLabelOrginY = ORGINY;
    CGFloat cityNameLabelWidth = cityNameSize.width;
    CGFloat cityNameLabelHeight = cityNameSize.height;
    self.cityNameLabel.frame = CGRectMake(cityNameLabelOrginX, cityNameLabelOrginY, cityNameLabelWidth, cityNameLabelHeight);
    self.cityNameLabel.text = _weather.cityName;
    
    NSString *pmString = [NSString stringWithFormat:@"PM:%@ %@",_weather.pm,_weather.pmLevel];
    CGSize pmSize = [self countTextSizeWithText:pmString textSize:TEXTFONTSMALL];
    CGFloat pmLabelOrginX = (kScreenWidth - pmSize.width)/2;
    CGFloat pmLabelOrainY = cityNameLabelOrginY + pmSize.height + PADDINGY;
    CGFloat pmLabelWidth = pmSize.width;
    CGFloat pmLabelHeight = pmSize.height;
    self.pmLabel.frame = CGRectMake(pmLabelOrginX, pmLabelOrainY, pmLabelWidth, pmLabelHeight);
    self.pmLabel.text = pmString;
    
    
    CGFloat pmColorViewOrainX = pmLabelOrginX;
    CGFloat pmColorViewOrginY = pmLabelOrainY + pmLabelHeight + PADDINGY;
    CGFloat pmColorVieWidth = pmLabelWidth;
    CGFloat pmColorViewHeight = 5;
    self.pmColorView.frame = CGRectMake(pmColorViewOrainX, pmColorViewOrginY, pmColorVieWidth, pmColorViewHeight);
    self.pmColorView.backgroundColor = [self pmColor];
    
    NSString *tempString = [NSString stringWithFormat:@"%@℃",_weather.temp];
    CGSize tempSize = [self countTextSizeWithText:tempString textSize:TEXTFONTBIG];
    CGFloat tempLabelOrginX = 20;
    CGFloat tempLabelOrginY = (kScreenHeight - tempSize.height)/2;
    CGFloat tempLabelWidth = tempSize.width;
    CGFloat tempLabelHeight = tempSize.height;
    self.tempLabel.frame = CGRectMake(tempLabelOrginX, tempLabelOrginY, tempLabelWidth, tempLabelHeight);
    self.tempLabel.text = tempString;
    
    
    NSString *weatherString = [NSString stringWithFormat:@"%@ %@ %@",_weather.weather,_weather.wind,_weather.windLevel];
    CGSize weatherSize = [self countTextSizeWithText:weatherString textSize:TEXTFONTNOMAL];
    CGFloat weatherLabelOrginX = tempLabelOrginX + tempLabelWidth +10;
    CGFloat weatherLabelOrginY = tempLabelOrginY + tempLabelHeight - weatherSize.height;
    CGFloat weatherLabelWidth = weatherSize.width;
    CGFloat weatherLabelHeight = weatherSize.height;
    self.weatherLabel.frame = CGRectMake(weatherLabelOrginX, weatherLabelOrginY, weatherLabelWidth, weatherLabelHeight);
    self.weatherLabel.text = weatherString;
    
    
    CGSize dateSize = [self countTextSizeWithText:_weather.date_y textSize:TEXTFONTNOMAL];
    CGFloat dateLabelOrginX = tempLabelOrginX;
    CGFloat dateLabelOrginY = tempLabelOrginY + tempLabelHeight + PADDINGY;
    CGFloat dateLabelWidth = dateSize.width;
    CGFloat dateLabelHeight = dateSize.height;
    self.dateLabel.frame = CGRectMake(dateLabelOrginX, dateLabelOrginY, dateLabelWidth, dateLabelHeight);
    self.dateLabel.text = _weather.date_y;
    
    [self fillFutureScrollView];
}



/**
 动态计算一段文字的大小尺寸，用来保证label可以显示所有的东西
 即适应文字大小
 */
-(CGSize)countTextSizeWithText:(NSString *)text textSize:(int)textFont{
    NSDictionary *attributeDict = @{
                                    NSFontAttributeName:[UIFont systemFontOfSize:textFont],
                                    };
    
    
    
    /**
     arg1：规定计算文字宽高范围 arg2：计算时的参考，参考字体大小和间距
     arg3：对文字描述用于计算文字尺寸
     arg4：一般为空

    kScreenWidth  宽度
    kScreenHeight 高度

     */
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight)
                                          options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attributeDict
                                          context:nil].size;
    return textSize;
    
}
-(void)getWeatherDataFromNetWork{
   //网络请求要确定网址
//    NSString *urlString = @"http://weather.123.duba.net/static/weather_info/101010100.html";
    //    NSURLConnection网络请求已经废弃了
    
    NSString *urlString = [NSString stringWithFormat:@"http://weather.123.duba.net/static/weather_info/%d.html",self.cityId];
    //获取全局的网络会话
    NSURLSession *session = [NSURLSession sharedSession];
    //设置网络路径
    NSURL *url = [NSURL URLWithString:urlString];
    //通过session创建网络请求任务
    
    //session 创建请求网络数据的任务参数1，网络路径 参数2，block类型的变量，block就是一个方法  这里的block参数是网络请求结束后的回调（网络请求后要执行的代码）
    
    //dataTaskWithURL是异步网络请求，该方法会启动一个后台进程去加载网络数据，加载结束后再*后台*线程执行block方法
    
    //NSURLSessionDataTask 是NSURLSession对象创建的网络请求
    
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSURLSessionDataTask *task =  [session dataTaskWithURL:url completionHandler:^(
                                                                                   
                                                                                   
    /** block中参数的含义
     *  data 网络请求到的二进制结果数据
     
     *
     **/
                                                            NSData * _Nullable data,
                                                            NSURLResponse * _Nullable response,
                                                            NSError * _Nullable error) {
//        block中的代码是在后台线程中执行的，当block代码执行的时候，说明后台线程完成了网络加载数据的任务，这时需要主线程去区里网络数据
        
        //切换回主线程 GCD  dispatch_async(arg1,arg2);异步线程切换，arg1说明要切换到哪个线程，arg2block：说明切换到该线程要做什么
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"test");
            
        
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            //写方法前先处理异常
            if (error) {
                //网络存在错误，这时界面应该有相应的处理，而不再是正常的逻辑
                NSLog(@"网络错误");
                return ;
            }
            if (!data) {
                NSLog(@"没有请求到数据");
                return;
            }
            
            //处理数据
            self.weather = [[Weather alloc]initWithWeatherData:data];
            
            [self reloadData];
            
        });
        NSLog(@"hello world");
    }];
    [task resume];
}


-(UIColor *)pmColor{
    UIColor *pmColor;
    if ([_weather.pmLevel containsString:@"优"]) {
        pmColor = [UIColor greenColor];
    }else if([_weather.pmLevel containsString:@"良"]){
        pmColor = [UIColor yellowColor];
    }else if ([_weather.pmLevel containsString:@"轻度污染"]){
        pmColor = [UIColor orangeColor];
    }else if ([_weather.pmLevel containsString:@"重度污染"]){
        pmColor = [UIColor purpleColor];
    }else{
        pmColor = [UIColor brownColor];
    }
    
    return pmColor;
}


-(void)search:(id)sender{
    
    SearchCityTableViewController *searchCityTableViewController = [[SearchCityTableViewController alloc]init];
    
    //给search页面的block赋值  cityCode
    searchCityTableViewController.completeBackHander = ^(int cityCode){
        //接受    searchCityTableViewController返回时的传值
        
        self.cityId = cityCode;
        [self getWeatherDataFromNetWork];
    
        
    };
    
    [self.navigationController pushViewController:searchCityTableViewController animated:YES];
}

-(void)refresh:(id)sender{
    
    [self getWeatherDataFromNetWork];
    
}


-(void)fillFutureScrollView{
    //scrollView内容的尺寸与控件的尺寸不一致，内容尺寸远大于控件的尺寸
    //定义scrollView内容的宽度高度
    CGFloat scrollViewContentHeight = 0;
    CGFloat scrollViewContentwidth = 0;
    
    //枚举型for循环， 循环遍历是不能改变数组元素的个数
    
    //通过枚举使一个数组中的所有元素，都执行一个指定的方法
    //futureWeatherScroller中所有的子控件，都执行removeFromSuperview
    [self.futureWeatherScroller.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (FutureWeather *futureWeather in _weather.futureWeatherArray) {
        FutureWeatherView *futureWeatherView = [[FutureWeatherView alloc]initWithFutureWeather:futureWeather];
        //自定义控件在ScrollView中的位置
        CGFloat futureWeatherViewOrginX = scrollViewContentwidth;
        CGFloat futureWeatherViewOrginY = 0;
        CGFloat futureWeatherViewWidth = futureWeatherView.frame.size.width;
        CGFloat futureWeatherViewHeight = futureWeatherView.frame.size.height;
        
        futureWeatherView.frame = CGRectMake(futureWeatherViewOrginX, futureWeatherViewOrginY, futureWeatherViewWidth, futureWeatherViewHeight);
        //添加到ScrollView中
        [self.futureWeatherScroller addSubview:futureWeatherView];
        
        //重新计算ScrollView的内容尺寸
        scrollViewContentwidth = scrollViewContentwidth + futureWeatherViewWidth;
        if (scrollViewContentHeight < futureWeatherViewHeight) {
            scrollViewContentHeight = futureWeatherViewHeight;
        }
    }
    
    //scrollView在页面中的位置和ScrollView的内容尺寸
    
    CGFloat scrollViewOrginX = 0;
    CGFloat scrollViewOrginY = kScreenHeight - scrollViewContentHeight;
    CGFloat scrollViewWidth = kScreenWidth;
    CGFloat scrollViewHeight = scrollViewContentHeight;
    
    self.futureWeatherScroller.frame = CGRectMake(scrollViewOrginX, scrollViewOrginY, scrollViewWidth, scrollViewHeight);
    self.futureWeatherScroller.contentSize = CGSizeMake(scrollViewContentwidth, scrollViewContentHeight);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
