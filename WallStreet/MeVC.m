//
//  MeVC.m
//  WallStreet
//
//  Created by qingyun on 16/4/24.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "MeVC.h"

#import "SDImageCache.h"

@interface MeVC ()

@end

@implementation MeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showAlertWithMessage:@"看新闻" withIndexPath:indexPath];
    } else if (indexPath.row == 1) {
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        CGFloat sizeM = (CGFloat)size/1024/1024;
        [self showAlertWithMessage:[NSString stringWithFormat:@"当前缓存: %f", sizeM] withIndexPath:indexPath];
    } else {
        [self showAlertWithMessage:@"blalala" withIndexPath:indexPath];
    }
}

- (void)showAlertWithMessage:(NSString *)message withIndexPath:(NSIndexPath *)index {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"一些信息" preferredStyle:UIAlertControllerStyleAlert];
    
    if (index.row == 1) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[SDImageCache sharedImageCache] clearDisk];
        }];
        [alert addAction:action];
    } else {
        UIAlertAction *action = [UIAlertAction actionWithTitle:message style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
    }
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
