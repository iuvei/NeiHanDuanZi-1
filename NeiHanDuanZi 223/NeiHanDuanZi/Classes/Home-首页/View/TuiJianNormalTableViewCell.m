//
//  TuiJianNormalTableViewCell.m
//  内涵App
//
//  Created by fuyuzheng on 2016/11/16.
//  Copyright © 2016年 ZCQ. All rights reserved.
//

#import "TuiJianNormalTableViewCell.h"
#import "ReturnTableViewCellHeight.h"
#import "ImgScrollView.h"
#import "AFNetworkingRequest.h"
#import "MoreImgView.h"
#import "CheckLongPicBtn.h"

@interface TuiJianNormalTableViewCell ()<UIScrollViewDelegate>

@property (nonatomic,assign)CGFloat height;

@property (strong, nonatomic) IBOutlet UIButton *digupBtn;
@property (strong, nonatomic) IBOutlet UIButton *digdownBtn;

@property (nonatomic,assign)BOOL isSelected;

@property (nonatomic,strong)ImgScrollView *imgScrollView;

@property (nonatomic,strong)UIScrollView *bottomScrollView;

@property (nonatomic,strong)NSString *longPicUrl;

@property (nonatomic,assign)CGFloat longPicHeight;

@property (nonatomic,strong)CheckLongPicBtn *longBtn;

@end

@implementation TuiJianNormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _isSelected = YES;
    
    self.userImage.layer.cornerRadius = 15;
    self.userImage.layer.masksToBounds = YES;
    
    self.kindBtn.layer.borderColor = [UIColor brownColor].CGColor;
    self.kindBtn.layer.borderWidth = 0.5;
    self.kindBtn.layer.cornerRadius = 11;
    self.kindBtn.layer.masksToBounds = YES;
    
    self.title.numberOfLines = 0;
    
    _shenPingBGView = [[[NSBundle mainBundle] loadNibNamed:@"ShenPingBgView" owner:nil options:nil] objectAtIndex:0];
    _shenPingBGView.userHeaderImage.layer.cornerRadius = 15;
    _shenPingBGView.userHeaderImage.layer.masksToBounds = YES;
    _shenPingBGView.frame = CGRectMake(0, 0, self.shenPingView.frame.size.width, self.shenPingView.frame.size.height);
    [self.shenPingView addSubview:_shenPingBGView];
    
    _videoView = [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] objectAtIndex:0];
    _videoView.frame = CGRectMake(0, 0, self.content.frame.size.width, self.content.frame.size.height);
    [self.content addSubview:_videoView];
    
    _longBtn = [[[NSBundle mainBundle] loadNibNamed:@"CheckLongPicBtn" owner:nil options:nil] lastObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataModelDic:(NSDictionary *)dataModelDic {
    
    NSDictionary *group = dataModelDic[@"group"];
    self.groupID = group[@"group_id"];
    NSArray *array = dataModelDic[@"comments"];
    
    //处理神评数据
    if (array.count>0) {
        
        _shenPingBGView.comment.text = [array[0] objectForKey:@"text"];
    
        _shenPingBGView.frame = CGRectMake(0, 0, self.shenPingView.frame.size.width, self.shenPingView.frame.size.height);
        [_shenPingBGView.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:[array[0] objectForKey:@"avatar_url"]]];
            
        _shenPingBGView.digupCount.text = [NSString stringWithFormat:@"%ld",[[array[0] objectForKey:@"digg_count"] integerValue]];
        _shenPingBGView.userName.text = [array[0] objectForKey:@"user_name"];
        
        [_shenPingBGView.userHeaderImage sd_setImageWithURL:[NSURL URLWithString:[array[0] objectForKey:@"avatar_url"]]];
        self.shenPingHeight.constant = [ReturnTableViewCellHeight dealWithString:_shenPingBGView.comment.text fontSize:13]+50+18;
        
    }
    else {
        self.shenPingHeight.constant = 0;
        [_shenPingBGView removeFromSuperview];
    }
    
    self.title.text = group[@"content"];
    //分类
    [self.kindBtn setTitle:group[@"category_name"] forState:UIControlStateNormal];
    //user
    _userDic = group[@"user"];
    self.userName.text = _userDic[@"name"];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:_userDic[@"avatar_url"]]];
    self.userID = _userDic[@"user_id"];
    
    //处理评论、点赞、转发、踩的数量
    [self dealWithdigupCount:[group[@"digg_count"] integerValue] caiCount:[group[@"bury_count"] integerValue] commentCount:[group[@"comment_count"] integerValue] shareCount:[group[@"share_count"] integerValue]];
    
    //如果数据类型是video
    if ([group[@"media_type"] integerValue] == 3) {
        
        //封面地址
        NSDictionary  *largeCover=group[@"large_cover"];
        NSArray *urlList=largeCover[@"url_list"];
        [_videoView.bgImage sd_setImageWithURL:[NSURL URLWithString:[urlList[0] objectForKey:@"url"]]];
        //视频地址
        NSDictionary *video=group[@"360p_video"];
        NSArray *videoUrllsit=video[@"url_list"];
        _videoView.urlString=[videoUrllsit[0] objectForKey:@"url"];
        
        //视频高度
        CGFloat videoHeight = [video[@"height"] floatValue];
        if (videoHeight > 300) {
            _videoHeight = 286;
        }
        else {
            _videoHeight = videoHeight;
        }
        self.contentHeight.constant = _videoHeight;
        //播放次数
        //设置播放数字为红色
        NSString *preStr = [NSString stringWithFormat:@"%ld",[group[@"play_count"] integerValue]];
        NSString *str = [NSString stringWithFormat:@"%ld次播放",[group[@"play_count"] integerValue]];
        NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:str];
        [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0, preStr.length)];
        _videoView.playCount.attributedText = mStr;
        //时长
        [self dealWithDuration:[group[@"duration"] floatValue]];
    }
    //如果数据类型是gif
    else if ([group[@"media_type"] integerValue] == 2) {
        
        [self.videoView.shadowView removeFromSuperview];
        [self.videoView.playBtn removeFromSuperview];
        
        NSDictionary *Imagedic = group[@"large_image"];
        NSArray *urlList=Imagedic[@"url_list"];
        
        [_videoView.bgImage sd_setImageWithURL:[NSURL URLWithString:[urlList[0] objectForKey:@"url"]]];
        
        //gif地址
        NSDictionary *video=group[@"gifvideo"];
        NSDictionary *videoUrllsit=video[@"360p_video"];
        NSArray *array = videoUrllsit[@"url_list"];
        _videoStr=[array[0] objectForKey:@"url"];
        //gif高度
        CGFloat height =[videoUrllsit[@"height"] floatValue];
        if (height >= 600) {
            
            _videoHeight = 600;
        }
        else {
            _videoHeight = height;
        }
        self.contentHeight.constant = _videoHeight;
    }
    //如果数据类型是文字
    else if ([group[@"media_type"] integerValue] == 0){
        
        self.contentHeight.constant = 0;
        [self.videoView removeFromSuperview];
        
    }
    //如果数据类型是图片
    else if ([group[@"media_type"] integerValue] == 1){
        
        [self.videoView.shadowView removeFromSuperview];
        [self.videoView.playBtn removeFromSuperview];
        NSDictionary *largeImagedic = group[@"large_image"];
        NSArray *urlList=largeImagedic[@"url_list"];
        [_videoView.bgImage sd_setImageWithURL:[NSURL URLWithString:[urlList[0] objectForKey:@"url"]]];
        _longPicUrl = [urlList[0] objectForKey:@"url"];
        _videoHeight=[largeImagedic[@"height"] floatValue];
        
        if (_videoHeight > 1000) {
            _videoView.bgImage.layer.contentsRect = CGRectMake(0, 0, 1, 400/_videoHeight);
            self.contentHeight.constant = 400;
            _longPicHeight = _videoHeight;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 400-45, ScreenWidth-20, 45);
            
            [button setTitle:@"查看大图" forState:UIControlStateNormal];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            [button setImage:[UIImage imageNamed:@"video_minimization"] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [self.content addSubview:button];
            
            [button addTarget:self action:@selector(checkLongPic:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        else {
            
            self.contentHeight.constant = _videoHeight;
        }
    }
    //如果数据类型是多图
    else {
    
        //创建imageView
        _videoView.hidden = YES;
        MoreImgView *imgView=[[MoreImgView alloc] initWithFrame:self.content.bounds];
        imgView.userInteractionEnabled = YES;
        NSArray *thumb_image_list=group[@"thumb_image_list"];
        imgView.urlArray=thumb_image_list;
        imgView.mUrlArray = group[@"large_image_list"];
        [self.content  addSubview:imgView];
        NSInteger num;
        if (thumb_image_list.count%3==0) {
            num=thumb_image_list.count/3;
        }
        else{
            num=(int)(thumb_image_list.count/3)+1;
            
        }
        self.contentHeight.constant=num*([UIScreen mainScreen].bounds.size.width-40)/3+(num-1)*5;
    }
}

#pragma mark --点击查看长图--
- (void)checkLongPic:(CheckLongPicBtn *)sender {
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth, _longPicHeight);
    _bottomScrollView.backgroundColor = [UIColor blackColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomScrollView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
    imgView.center = _bottomScrollView.center;
    [_bottomScrollView addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_longPicUrl]];
    [UIView animateWithDuration:0.5 animations:^{
        imgView.frame = CGRectMake(0, 0, ScreenWidth, _longPicHeight);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongPic:)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap];
    
}

#pragma mark --点击手势--
- (void)tapLongPic:(UITapGestureRecognizer *)sender {
    
    [_bottomScrollView removeFromSuperview];
}


#pragma mark --scrollView delegate--
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
    
}


-(UIImage*)sceptWithSourceImg:(UIImage*)sourceImg{
    
    if (sourceImg == nil) {
        return nil;
    }
    
    //拿到原图的尺寸
    CGSize size=sourceImg.size;
    CGFloat oldH=size.height;
    CGFloat oldW=size.width;
    CGFloat rite=oldH/oldW;
    CGFloat newH=(ScreenWidth-20)*rite;
    
    CGRect newRect=CGRectMake(0, 0, ScreenWidth-20, newH);
    CGSize newSize=CGSizeMake(ScreenWidth-20, newH);
    UIGraphicsBeginImageContext(newSize);
    
    [sourceImg drawInRect:newRect];
    UIImage *newImg=[[UIImage alloc]init];
    newImg=UIGraphicsGetImageFromCurrentImageContext();
    
    if (newImg==nil) {
        NSLog(@"失败");
    }
    return newImg;
    
}

//处理播放时间，点赞数
- (void)dealWithdigupCount:(NSInteger)digupCount caiCount:(NSInteger)caicount commentCount:(NSInteger)commentCount shareCount:(NSInteger)shareCount {
    
    if (digupCount>=10000) {
        CGFloat digCount = digupCount/10000.0;
        self.digupCount.text = [NSString stringWithFormat:@"%.1f万",digCount];
    }
    else{
        self.digupCount.text = [NSString stringWithFormat:@"%ld",digupCount];
    }
    if (caicount>=10000) {
        CGFloat caiCount = caicount/10000.0;
        self.caicount.text = [NSString stringWithFormat:@"%.1f万",caiCount];
    }
    else{
        self.caicount.text = [NSString stringWithFormat:@"%ld",caicount];
    }
    if (commentCount>=10000) {
        CGFloat comment = commentCount/10000.0;
        self.commentcount.text = [NSString stringWithFormat:@"%.1f万",comment];
    }
    else{
        self.commentcount.text = [NSString stringWithFormat:@"%ld",commentCount];
    }
    if (shareCount>=10000) {
        CGFloat share = shareCount/10000.0;
        self.sharecount.text = [NSString stringWithFormat:@"%.1f万",share];
    }
    else{
        self.sharecount.text = [NSString stringWithFormat:@"%ld",shareCount];
    }
}

//处理播放时间
- (void)dealWithDuration:(CGFloat)duration {
    
    NSString *timeStr = [NSString stringWithFormat:@"%f",duration];
    NSArray *array = [timeStr componentsSeparatedByString:@"."];
    NSString *time = array[0];
    int t = [time intValue];
    
    int minute = t/60;
    int second = t%60;
    
    self.videoView.time.text = [NSString stringWithFormat:@"%d:%02d",minute,second];
}

#pragma mark --右上角删除按钮--

- (IBAction)didSelectedDislikeButtonAction:(UIButton *)sender {
    
    NSLog(@"删除");
    
}

#pragma mark --点赞、踩、评论、转发--
- (IBAction)digUpAction:(UIButton *)sender {
    NSLog(@"digUp");
    
    if (_isSelected == YES) {
        
        [UIView animateWithDuration:1 animations:^{
            
            [sender setImage:[UIImage imageNamed:@"digupicon_textpage_press"] forState:UIControlStateNormal];
            _isSelected = !_isSelected;
        }];
    }
    

    

    
}

- (IBAction)digDownAction:(UIButton *)sender {
    NSLog(@"digDown");
    
    if (_isSelected == YES) {
        
        [UIView animateWithDuration:1 animations:^{
            
            [sender setImage:[UIImage imageNamed:@"digdownicon_textpage_press"] forState:UIControlStateNormal];
            _isSelected = !_isSelected;
        }];
        
    }
    
    
}

- (IBAction)commentAction:(UIButton *)sender {
    NSLog(@"comment");
}

- (IBAction)shareAction:(UIButton *)sender {
    NSLog(@"share");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showShareView" object:self];
    
    
    
}

- (IBAction)categoryNameAction:(UIButton *)sender {
    NSLog(@"category_name");
    
    
    
    
}

@end
