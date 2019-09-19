//
//  OHViewControllerGameView.m
//  OneHundred
//
//  Created by Вадим on 12.07.14.
//  Copyright (c) 2014 Вадим. All rights reserved.
//

#import "OHViewControllerGameView.h"
#define RAND_FROM_TO() (1 + arc4random_uniform(9 - 1 + 1))
#define RAND_FROM_TO_100_300() (100 + arc4random_uniform(300 - 100 + 1))

struct PARAM {
    BOOL _repl;
    BOOL _d6d3;
    BOOL _time;
    BOOL _iAd;
};

@interface OHViewControllerGameView ()
{
    int _scoreSecond;
    int _scoreEnd;
    int _colSelectNoRep;
    int _endRes;
    int _lCol;
    int _rCol;
    int __stst__; // 0 start, 1 pause, 2 gameOver, 3 gameWin
    NSTimer* _timerTickSeck;
    CGRect _blockNoActive;
    struct PARAM _param_;
    NSArray *_paramFunctions;
    UILabel *_selectLabelDisplay;
    UILabel *_selectLabelCalculator;
    UIViewController *_gameCenterView;
    BOOL _bannerVisible;
    ADBannerView *_bannerView;
}

- (void)refresh;
- (void)zero:(BOOL)st;
- (void)gameOver;
- (BOOL)rectToRectBlock:(CGRect)block rectPoint:(CGPoint)point;

@property (nonatomic) BOOL gameCenterEnabled;

-(void)authenticateLocalPlayer;

@end

@implementation OHViewControllerGameView

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    NSDictionary *_tmp_ = [OHUtils getSetting];
    BOOL stReset = NO;
    if ([[_tmp_ objectForKey:@"six_or_three_digits"] boolValue] != _param_._d6d3) {
        stReset = YES;
    }
    _paramFunctions = [_tmp_ objectForKey:@"functions"];
    _param_._d6d3 = [[_tmp_ objectForKey:@"six_or_three_digits"] boolValue];
    _param_._repl = NO;
    _param_._time = _param_._d6d3;
    _param_._iAd = [[_tmp_ objectForKey:@"iAd"] boolValue];

    if (stReset) {
        [self refresh];
    }

    [self.labelTick setHidden:!_param_._time];
    if (__stst__ == 1) __stst__ = 0;
    
    if (_param_._iAd) {
        if (_bannerView == nil) {
            _bannerView = [[ADBannerView alloc] initWithFrame: CGRectMake(0.0f, -50.0f, 320.0f, 50.0f)];
            _bannerView.delegate = self;
            [self.view addSubview:_bannerView];
        }
    } else if(_bannerView != nil) {
        _bannerView.frame = CGRectMake(0, -50.0f, _bannerView.frame.size.width, _bannerView.frame.size.height);
        _bannerView.delegate = nil;
        _bannerView = nil;
        _bannerVisible = NO;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    NSInteger __len__ = [_paramFunctions count];
    int __count__ = 0;
    for(int i=0; i<__len__; i++) {
        if ([[_paramFunctions objectAtIndex:i] boolValue]) {
            __count__ += 1;
        }
    }

    float _w_ = self.view.frame.size.width;
    float step = (__count__%2?(_w_ / 2.0f):_w_) / (__count__ == 5 || __count__ == 2?3:(__count__==4?5:(__count__==3?2:1)));
    float _xx_ = 0.0f;
    for(int i=0; i<__len__; i++) {
        if ([[_paramFunctions objectAtIndex:i] boolValue]) {
            _xx_ = _xx_ + step;
            CGRect rect = [[self.actionCalculators objectAtIndex:i] frame];
            [[self.actionCalculators objectAtIndex:i] setFrame:CGRectMake((_xx_ - (rect.size.width / 2)), rect.origin.y, rect.size.width, rect.size.height)];
            [[self.actionCalculators objectAtIndex:i] setHidden:NO];
        } else {
            [[self.actionCalculators objectAtIndex:i] setHidden:YES];
        }
    }
    
    [self.labelColLeft setHidden:YES];
    [self.labelColRight setHidden:YES];
    if (_param_._d6d3 == NO) {
        CGRect labD = [(UILabel*)[self.labelsDisplay objectAtIndex:0] frame];
        step = _w_ / 7;
        _xx_ = 0.0f;
        for(int i=0; i<6; i++) {
            if (i == 0) {
                _xx_ = step - 5.0f;
            } else if (i == 3) {
                _xx_ = (_xx_ + step) + 10.0f;
            } else {
                _xx_ = (_xx_ + step);
            }
            labD.origin.x = _xx_ - (labD.size.width / 2.0f);
            [(UILabel*)[self.labelsDisplay objectAtIndex:i] setFrame:labD];
        }
        [self.lineSeparator setHidden:NO];
        [self.labelResult setHidden:YES];
        [self.labelEndScet setHidden:YES];
        [self.labelResultLeft setHidden:NO];
        [self.labelResultRight setHidden:NO];
        [self.labelSeparatorEqually setHidden:NO];
        if (_param_._repl == NO) {
            [self.labelColLeft setHidden:NO];
            [self.labelColRight setHidden:NO];
        }
    } else {
        [self.lineSeparator setHidden:YES];
        [self.labelResult setHidden:NO];
        [self.labelEndScet setHidden:NO];
        [self.labelResultLeft setHidden:YES];
        [self.labelResultRight setHidden:YES];
        [self.labelSeparatorEqually setHidden:YES];
    }
    
    CGRect tmp = self.labelTick.frame;
    if (_bannerVisible) {
        tmp.origin.y = 55;
    } else {
        tmp.origin.y = 5;
    }
    self.labelTick.frame = tmp;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.toolBar.layer setMasksToBounds:YES];
    [self.toolBar.layer setBorderWidth:0.0f];
    [self.view setBackgroundColor:self.resours.colorBG];

    [self.labelTick setTextColor:self.resours.colorblackActive];
    [self.labelEndScet setTextColor:self.resours.colorgrenNoActive];
    [self.labelResult setTextColor:self.resours.colorblackActive];
    [self.labelResultLeft setTextColor:self.resours.colorblackActive];
    [self.labelResultRight setFont:self.resours.fontOpenSansLight36];
    [self.labelTick setFont:self.resours.fontOpenSansSemibold12];
    [self.labelGameStatus setFont:self.resours.fontOpenSansSemibold12];
    [self.labelEndScet setFont:self.resours.fontOpenSansLight15];
    [self.labelResult setFont:self.resours.fontOpenSansLight36];
    [self.labelResultLeft setFont:self.resours.fontOpenSansLight36];
    [self.labelResultRight setTextColor:self.resours.colorblackActive];
    [self.labelColLeft setFont:self.resours.fontOpenSansLight15];
    [self.labelColRight setFont:self.resours.fontOpenSansLight15];
    [self.labelEndScet setTextColor:[UIColor colorWithRed:0.9254901960784314f green:0.4627450980392157f blue:0.12156862745098039f alpha:1.0f]];

    for (UILabel *label in self.labelsDisplay) {
        [label setFont:self.resours.fontOpenSansLight70];
    }
    for (UILabel *label in self.actionCalculators) {
        [label setFont:self.resours.fontOpenSansLight48];
        [label setTextColor:self.resours.colorblackActive];
    }

    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];

    if ([[[OHUtils getSetting] objectForKey:@"audio_param"] boolValue]) {
        [SoundManager sharedManager].musicVolume = 0.9f;
        [SoundManager sharedManager].soundVolume = 1.0f;
    } else {
        [SoundManager sharedManager].musicVolume = 0.0f;
        [SoundManager sharedManager].soundVolume = 0.0f;
    }

    _timerTickSeck = [NSTimer scheduledTimerWithTimeInterval:0.019f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self authenticateLocalPlayer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([[segue identifier] isEqualToString:@"setting"]) {
        if (__stst__ == 0) __stst__ = 1;
    }
}

/* iAd Banner */
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (_bannerVisible == NO) {
        _bannerVisible = YES;
        banner.frame = CGRectMake(0, 0, banner.frame.size.width, banner.frame.size.height);
        self.timerConstain.constant = 55;
    }
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_bannerVisible) {
        _bannerVisible = NO;
        banner.frame = CGRectMake(0, -50.0f, banner.frame.size.width, banner.frame.size.height);
        self.timerConstain.constant = 5;
    }
}
/* end iAd */

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (__stst__ != 0) return;

    // Получение коордитан клацка
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];

    // Переключение блока левый правый
    if (_param_._d6d3 == NO) {
        if ([self rectToRectBlock:_blockNoActive rectPoint:location]) {
            _blockNoActive.origin.x = _blockNoActive.origin.x > 0?0.0f:_blockNoActive.size.width;
            for (UILabel *label in self.labelsDisplay) {
                if ([label alpha] == 1.0f) {
                    [label setAlpha:0.6f];
                } else if ([label alpha] == 0.6f) {
                    [label setAlpha:1.0f];
                }
            }
            if (_blockNoActive.origin.x <= 0.0f) {
                if ([self.labelColRight alpha] == 0.6f)[self.labelColRight setAlpha:1.0f];
                if ([self.labelColLeft alpha] == 1.0f)[self.labelColLeft setAlpha:0.6f];
            } else {
                if ([self.labelColRight alpha] == 1.0f)[self.labelColRight setAlpha:0.6f];
                if ([self.labelColLeft alpha] == 0.6f)[self.labelColLeft setAlpha:1.0f];
            }
            
            [_selectLabelDisplay setTextColor:self.resours.colorblackActive];
            [_selectLabelCalculator setTextColor:self.resours.colorblackActive];
            _selectLabelCalculator = nil;
            _selectLabelDisplay = nil;
            return;
        }
    }

    int result;
    int selectDisplay = 0;

    // Сброс цвета выделеного числа
    if (_selectLabelDisplay) {
        [_selectLabelDisplay setTextColor:self.resours.colorblackActive];
    }
    // проверяем было ли кликнуто на какое нибудь из чисел
    if (self.labelsDisplay.count > 0) {
        for (UILabel *label in self.labelsDisplay) {
            CGRect __lab__ = [label frame];
            if ([self rectToRectBlock:__lab__ rectPoint:location] && [label alpha] == 1.0f) {
                _selectLabelDisplay = label;
            }
            if ([label alpha] == 0.4f) {
                [label setAlpha:1.0f];
            }
        }
    }

    // выбор результана 6 или 3 цифры
    if (_param_._d6d3) {
        result = [[_labelResult text] intValue];
    } else {
        if (_blockNoActive.origin.x > 0) {
            result = [[_labelResultLeft text] intValue];
        } else {
            result = [[_labelResultRight text] intValue];
        }
    }

    if (_selectLabelDisplay) {
        // Устанавливаем оранжевый цвет выделеного числа  №
        [_selectLabelDisplay setTextColor:[UIColor colorWithRed:0.9254901960784314f green:0.4627450980392157f blue:0.12156862745098039f alpha:1.0f]];

        // Пулучаем в INT выделеного числа
        selectDisplay = [[_selectLabelDisplay text] intValue];
    
        // Дисабле функции которые дают не действительный результат
        if ((result - selectDisplay) <= 0) {
            [[self.actionCalculators objectAtIndex:1] setAlpha:0.3f];
        } else {
            [[self.actionCalculators objectAtIndex:1] setAlpha:1.0f];
        }
        if ((result * selectDisplay) <= 0) {
            [[self.actionCalculators objectAtIndex:2] setAlpha:0.3f];
        } else {
            [[self.actionCalculators objectAtIndex:2] setAlpha:1.0f];
        }
        if ((result / selectDisplay) <= 0) {
            [[self.actionCalculators objectAtIndex:3] setAlpha:0.3f];
        } else {
            [[self.actionCalculators objectAtIndex:3] setAlpha:1.0f];
        }
        if (pow(result, selectDisplay) > 9999999 || pow(result, selectDisplay) <= 0) {
            [[self.actionCalculators objectAtIndex:4] setAlpha:0.3f];
        } else {
            [[self.actionCalculators objectAtIndex:4] setAlpha:1.0f];
        }
    }

    // Проверяем было ли кликнуто по какой нибудь активной функции
    for (UILabel *label in self.actionCalculators) {
        CGRect __lab__ = [label frame];
        if ([self rectToRectBlock:__lab__ rectPoint:location] && [label alpha] == 1.0f && ![label isHidden]) {
            _selectLabelCalculator = label;
        }
        [label setTextColor:self.resours.colorblackActive];
    }
    // Если не одного из числа не выбрано но выбрана функци то проверяем на числа которые выведут рез меньше 0
    NSInteger tagSelectImage = [_selectLabelCalculator tag];
    if ((!_selectLabelDisplay && _selectLabelCalculator)) {
        [_selectLabelCalculator setTextColor:[UIColor colorWithRed:0.9254901960784314f green:0.4627450980392157f blue:0.12156862745098039f alpha:1.0f]];
        if ((tagSelectImage == 1 || tagSelectImage == 3 || tagSelectImage == 4)) {
            for (UILabel *label in self.labelsDisplay) {
                if ([label alpha] == 0.3f || [label alpha] == 0.6f) continue;
                switch (tagSelectImage) {
                    case 1:
                        if ((result - [[label text] intValue]) <= 0) {
                            [label setAlpha:0.4f];
                    }
                    break;
                    case 3:
                        if ((result / [[label text] intValue]) <= 0) {
                            [label setAlpha:0.4f];
                        }
                        break;
                    case 4:
                        if (pow(result, [[label text] intValue]) > 9999999) {
                            [label setAlpha:0.4f];
                        }
                        break;
                }
            }
        }
    }

    // Если нет выходим
    if (!_selectLabelDisplay || !_selectLabelCalculator) return;

    // Выполнение действия функии
    switch (tagSelectImage) {
        case 0:
            result = result + selectDisplay;
            break;
        case 1:
            result = result - selectDisplay;
            break;
        case 2:
            result = result * selectDisplay;
            break;
        case 3:
            if (selectDisplay <= 0) {
                result = 0;
            } else {
                result = result / selectDisplay;
            }
            break;
        case 4:
            result = pow(result, selectDisplay);
            break;
    }

    if (result > 0) {
        [self zero:NO];
    } else {
        [self zero:YES];
        result = 0;
    }
    
    _scoreEnd = result;
    
    // Вывод результата на экран 6 или 3 цифры
    if (_param_._d6d3) {
        [_labelResult setText:[NSString stringWithFormat:@"%d", result]];
    } else {
        if ([_selectLabelDisplay tag] <= 2) {
            [_labelResultLeft setText:[NSString stringWithFormat:@"%d", result]];
        } else {
            [_labelResultRight setText:[NSString stringWithFormat:@"%d", result]];
        }
        if (_param_._repl == NO) {
            if (_blockNoActive.origin.x <= 0.0f) {
                _rCol -= 1;
            } else {
                _lCol -= 1;
            }
            if (_lCol <= 0.0f) {
                [self.labelColLeft setAlpha:0.3f];
            }
            if (_rCol <= 0.0f) {
                [self.labelColRight setAlpha:0.3f];
            }
            [self.labelColLeft setText:[NSString stringWithFormat:@"%d", _lCol]];
            [self.labelColRight setText:[NSString stringWithFormat:@"%d", _rCol]];
        }
    }

    // Сброс действий
    if (_param_._repl) {
        [_selectLabelDisplay setText:[NSString stringWithFormat:@"%i", RAND_FROM_TO()]];
    } else {
        [_selectLabelDisplay setAlpha:0.3f];
        _colSelectNoRep += 1;
    }
    [_selectLabelDisplay setTextColor:self.resours.colorblackActive];
    _selectLabelDisplay = nil;
    _selectLabelCalculator = nil;
    
    [[SoundManager sharedManager] playSound:@"soundSucFunktion.wav" looping:NO];
    
    // Проверка результата 6 или 3 цифры
    if (_param_._d6d3) {
        if (result == _endRes) {
            [self gameWin];
        } else if (/*result > _endRes ||*/_colSelectNoRep >= 6) {
            [self gameOver];
        }
    } else {
        NSInteger lRes = [[self.labelResultLeft text] integerValue];
        NSInteger rRes = [[self.labelResultRight text] integerValue];
        if (lRes == rRes) {
            [self gameWin];
        } else if (lRes > 9999999 || rRes > 9999999  || _colSelectNoRep >= 6) {
            [self gameOver];
        }
    }

    // END
}

- (IBAction)refreshAction:(id)sender {
    [self refresh];
}

- (IBAction)topAction:(id)sender {
    if (_gameCenterEnabled) {
        UIViewController *viewControllerTop = [[self.navigationController storyboard] instantiateViewControllerWithIdentifier:@"top"];
        [self.navigationController pushViewController:viewControllerTop animated:YES];
        if (__stst__ == 0) __stst__ = 1;
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
    }
}

- (void)onTick
{
    if (__stst__ != 0 || _param_._time == NO) return;
    int mmm, sss, ms;
    mmm = _scoreSecond / 3600;
    sss = _scoreSecond / 60;
    ms = _scoreSecond / 1;
    mmm = mmm % 3600;
    sss = sss % 60;
    ms = ms % 60;

    self.labelTick.text = [NSString stringWithFormat:@"%d:%.2i:%.2i", mmm, sss, ms];
    
    if (mmm >= 59){
        [self gameOver];
        return;
    }
    
    _scoreSecond += 1;
}

- (BOOL) rectToRectBlock:(CGRect)block rectPoint:(CGPoint)point
{
    if ((point.x >= block.origin.x && point.x <= (block.origin.x + block.size.width) && point.y >= block.origin.y && point.y <= (block.origin.y + block.size.height))) {
        return YES;
    } else {
        return NO;
    }
}

- (void) refresh
{
    _lCol = 3;
    _rCol = 3;
    _scoreEnd = 0;
    _scoreSecond = 0;
    _colSelectNoRep = 0;
    _selectLabelDisplay = nil;
    _selectLabelCalculator = nil;
    [self.labelResult setText:@"0"];
    [self.labelResultLeft setText:@"0"];
    [self.labelResultRight setText:@"0"];
    [self.labelColLeft setText:@"3"];
    [self.labelColRight setText:@"3"];
    [self.labelGameStatus setHidden:YES];
    [self.labelColLeft setAlpha:1.0f];
    [self.labelColRight setAlpha:0.6f];
    [self zero:YES];
    _endRes = RAND_FROM_TO_100_300();
    self.labelEndScet.text = [NSString stringWithFormat:@"%d", _endRes];

    _blockNoActive.origin.x = self.view.frame.size.width / 2;
    _blockNoActive.origin.y = [[self.labelsDisplay objectAtIndex:0] frame].origin.y;
    _blockNoActive.size.width = self.view.frame.size.width / 2;
    _blockNoActive.size.height = [[self.labelsDisplay objectAtIndex:0] frame].size.height;
    
    int i = 0;
    for (UILabel *label in self.labelsDisplay) {
        [label setTextColor: self.resours.colorblackActive];
        int _rand_;
        _rand_ = 0;
        if (_param_._d6d3 == NO && i >= 3) {
            [label setAlpha:0.6f];
            int wh = 1;
            while (wh) {
                _rand_ = RAND_FROM_TO();
                for (int j = 0; j < 3; j++) {
                    if (_rand_ == [[[self.labelsDisplay objectAtIndex:j] text] intValue]) {
                        wh = 1;
                        break;
                    } else {
                        wh = 0;
                    }
                }
            }
        } else {
            [label setAlpha:1.0f];
            _rand_ = RAND_FROM_TO();
        }
        [label setText:[NSString stringWithFormat:@"%il", _rand_]];
        i += 1;
    }
    __stst__ = 0;
}

- (void)zero:(BOOL)st
{
    int i = 0;
    for (UILabel *label in self.actionCalculators) {
        if (i > 0) {
            [label setAlpha:st?0.3f:1.0f];
        } else {
            [label setAlpha:1.0f];
        }
        [label setTextColor:self.resours.colorblackActive];
        i += 1;
    }
}

- (void)gameOver
{
    [[SoundManager sharedManager] stopMusic];
    [[SoundManager sharedManager] playMusic:@"game-over.wav" looping:NO];
    [self.labelGameStatus setText:NSLocalizedString(@"GameOver", nil)];
    [self.labelGameStatus setTextColor:[UIColor colorWithRed:0.84705882f green:0.0f blue:0.066666667f alpha:1.0f]];
    [self.labelGameStatus setHidden:NO];
    __stst__ = 2;
}

- (void)gameWin
{
    [[SoundManager sharedManager] stopMusic];
    [self.labelGameStatus setText:NSLocalizedString(@"GameWin", nil)];
    [self.labelGameStatus setTextColor:[UIColor colorWithRed:0.15686275f green:0.75294118f blue:0.14117647f alpha:1.0f]];
    [self.labelGameStatus setHidden:NO];
    __stst__ = 3;

    if (_gameCenterEnabled == YES) {
        int idIndexObj = _param_._d6d3 && _param_._repl?0:_param_._d6d3 && !_param_._repl?1:!_param_._d6d3 && _param_._repl?2:3;
        GKScore *score = [[GKScore alloc] initWithCategory:[self.resours.leaderboardIDs objectAtIndex:idIndexObj]];
        score.context = 0;
        if (_param_._d6d3) {
            score.value = _scoreSecond - 1;
        } else {
            score.value = _scoreEnd;
        }
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
            }
        }];
    }
}
/**/
-(void)authenticateLocalPlayer
{
    if (_gameCenterEnabled == YES) return;
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            _gameCenterView = viewController;
            [self presentViewController:_gameCenterView animated:YES completion:nil];
            if (__stst__ == 0) __stst__ = 1;
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                NSLog(@"GC: 1");
            } else {
                _gameCenterEnabled = NO;
                NSLog(@"GC: 0");
            }
            if (__stst__ == 1) __stst__ = 0;
        }
        NSLog(@"%@", error);
    };
}

@end
