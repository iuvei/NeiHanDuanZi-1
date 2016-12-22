//
//  TopTableViewCell.m
//  
//
//  Created by fuyuzheng on 2016/11/22.
//
//

#import "TopTableViewCell.h"
#import "RLScrollPic.h"
@implementation TopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


-(void)setImgArray:(NSMutableArray *)imgArray{

   RLScrollPic *scrollPic=[[RLScrollPic alloc]initWithFrame:self.bounds WithImageName:imgArray];
    [self.scrollView addSubview:scrollPic];



}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
