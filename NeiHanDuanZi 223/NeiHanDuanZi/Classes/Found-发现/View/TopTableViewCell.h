//
//  TopTableViewCell.h
//  
//
//  Created by fuyuzheng on 2016/11/22.
//
//

#import <UIKit/UIKit.h>

@interface TopTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray *imgArray;
@end
