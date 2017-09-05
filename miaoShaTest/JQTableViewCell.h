//
//  JQTableViewCell.h
//  openglStudy
//
//  Created by Monstar on 2017/9/4.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLineLabel;


@property (nonatomic, copy)NSString *cellID;

+ (JQTableViewCell *)initWith:(UITableView *)tableView;
@end
