//
//  SearchCityTableViewController.m
//  Weather
//
//  Created by F&Easy on 16/10/12.
//  Copyright © 2016年 F&Easy. All rights reserved.
//

#import "SearchCityTableViewController.h"
#import "XMLTools.h"
#import "ShowWeatherViewController.h"

@interface SearchCityTableViewController ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)NSDictionary *cityCityCodeDict;
@property(nonatomic,strong)NSArray *cityNameArray;
@property(nonatomic,strong)NSMutableArray *searchCityNameArray;

@end

@implementation SearchCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"搜索城市";
    
    
    
    //搜索条的设置
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    
    //设置搜索时，背景颜色会变暗
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    //搜索时导航栏隐藏
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    //设置搜索框的frame
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44);
    //把搜索框添加到页面
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    [self getCityCityCodeByXMLFile];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//(void(^)())task block参数  (void(^)(参数))task
-(void)doInBackGround:(void(^)())task{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        task();
    });
}


-(void)getCityCityCodeByXMLFile{
    [self doInBackGround:^{
        //找到文件路径
        NSString *filePathString = [[NSBundle mainBundle] pathForResource:@"city_code" ofType:@"xml"];
        
        //读取文件内容，并解析文件内容
        
        XMLTools *tools = [[XMLTools alloc]initWithFilePath:filePathString];
        self.cityCityCodeDict = [tools getResultDict];
        
        //获取表格的数据源
        self.cityNameArray = [self.cityCityCodeDict allKeys];
        //刷新表格
        [self.tableView reloadData];
        NSLog(@"%@",self.cityCityCodeDict);
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source


//找列表的数据源： 城市名字的数组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    if (self.searchController.active) {
        return self.searchCityNameArray.count;
    }
    return self.cityNameArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"resultIdentifier";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:indentifier];
    //如果tableView没有加载满，所以dequeueReusableCellWithIdentifier找不到可以复用的cell，这时要创建cell给tableView
    
    if (!cell) {
       
        //创建cell
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    
    //indexPath就是要加载的这一行cell在TableView中的坐标
    //indexPath.section (那个分区）
    //indexPath.row（第几行）
    if (self.searchController.active) {
        cell.textLabel.text = self.searchCityNameArray[indexPath.row];
    }else{
        cell.textLabel.text = self.cityNameArray[indexPath.row];
    }
    // Configure the cell...
    
    return cell;
}
//当searchBar检测到输入框中有内容变化时就会调用该方法（在此方法中写搜索逻辑）


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cityNameSelected;
    
    //区分搜索页面和普通页面
    
    if (self.searchController.active) {
        cityNameSelected = self.searchCityNameArray[indexPath.row];
    }else{
        cityNameSelected = self.cityNameArray[indexPath.row];
    }
    
    [self searchCityFinish:cityNameSelected];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)searchCityFinish:(NSString *)cityName{
    
    //获取cityName所对应的cityId
    
    //先异常处理
    if (cityName == nil || cityName.length == 0) {
        return;
    }
    NSString *cityId = [self.cityCityCodeDict valueForKey:cityName];
    
    if (cityId == nil || cityId.length == 0) {
        return;
    }
    
    //执行在show 中定义的  回调方法
    self.completeBackHander([cityId intValue]);
    
    //实现页面跳转
    
    
    
    if (self.searchController.active) {
//
//        [self presentViewController: animated: completion:]
        
        //搜索框出现时，应先放下
        [self dismissViewControllerAnimated:YES completion:^{
            //当页面消失后调用的代码
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UISearchUpdating deleagte
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    //获取输入框中的内容
    NSString *searchString = self.searchController.searchBar.text;
    //从self.cityNameArray中获取包含有searchString的所有城市的名字，要用一个成员变量的数组来保存这些搜索结果
    
    //通过谓词从数组中筛选符合条件的项
    /*
     谓词，就像sql语句一样
     */
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c]%@",searchString];
    
    //通过谓词筛选符合的项
    self.searchCityNameArray = [NSMutableArray arrayWithArray:[self.cityNameArray filteredArrayUsingPredicate:predicate]];
    
    [self.tableView reloadData];
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
