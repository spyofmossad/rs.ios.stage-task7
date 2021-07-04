//
//  LoginViewController.m
//  RsTask7
//
//  Created by Dzmitry Navitski on 01.07.2021.
//

#import "LoginViewController.h"
#import "HighlightedButton.h"

@interface LoginViewController ()

@property (strong, nonatomic) UITextField *login;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) HighlightedButton *authorize;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UILabel *secureCode;

@property NSMutableArray *secureCodeBuffer;
@property NSMutableArray<HighlightedButton *> *secureButtons;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.secureButtons = [NSMutableArray new];
    self.secureCodeBuffer = [NSMutableArray new];
    
    [self setupSubViews];
    [self setupTargetsAndDelegates];
    [self updateCodeLabel];
        
    self.containerView.hidden = true;
}

- (void)authOnTap {
    BOOL isLoginValid = [self validateInput: self.login valueEquals:USERNAME];
    BOOL isPasswordValid = [self validateInput: self.password valueEquals:PASSWORD];
    if (isLoginValid && isPasswordValid) {
        [self disableInputs];
        [self containerView].hidden = false;
    }
}

- (void)secureOnTap:(UIButton *) sender {
    [self.secureCodeBuffer addObject: [@(sender.tag) stringValue]];
    [self updateCodeLabel];
    [self validateCode];
}

- (void)dismissKeyboardOnTap {
    [self.login resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)validateInput:(UITextField *) field valueEquals:(NSString *) expected {
    if ([field.text isEqual: expected]) {
        return YES;
    }
    field.layer.borderColor = [UIColor colorNamed: @"VenetianRed"].CGColor;
    return NO;
}
    
- (void)disableInputs {
    self.login.enabled = false;
    self.login.alpha = 0.5f;
    self.login.layer.borderColor = [UIColor colorNamed: @"TurqGreen"].CGColor;
    
    self.password.enabled = false;
    self.password.alpha = 0.5f;
    self.password.layer.borderColor = [UIColor colorNamed: @"TurqGreen"].CGColor;
    
    self.authorize.enabled = false;
    self.authorize.alpha = 0.5f;
}

- (void)updateCodeLabel {
    if (self.secureCodeBuffer.count == 0) {
        self.secureCode.text = @"_";
    } else {
        self.containerView.layer.borderWidth = 0;
        self.secureCode.text = [[self.secureCodeBuffer valueForKey:@"description"] componentsJoinedByString:@" "];
    }
}

- (void)validateCode {
    if (self.secureCodeBuffer.count == 3) {
        NSString *enteredCode = [[self.secureCodeBuffer valueForKey:@"description"] componentsJoinedByString:@""];
        if ([enteredCode isEqual:SECURE_CODE]) {
            self.containerView.layer.borderColor = [UIColor colorNamed:@"TurqGreen"].CGColor;
            self.containerView.layer.borderWidth = 2;
            [self showAlert];
        } else {
            [self.secureCodeBuffer removeAllObjects];
            self.secureCode.text = @"_";
            self.containerView.layer.borderWidth = 2;
            self.containerView.layer.borderColor = [UIColor colorNamed:@"VenetianRed"].CGColor;
        }
    }
}

- (void)setupTargetsAndDelegates {
    self.login.delegate = self;
    self.password.delegate = self;
    [self.authorize addTarget:self action:@selector(authOnTap) forControlEvents:UIControlEventTouchUpInside];
    for (HighlightedButton *button in self.secureButtons) {
        [button addTarget:self action:@selector(secureOnTap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardOnTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)setupSubViews {
    self.view.backgroundColor = UIColor.whiteColor;
    
    //MARK: Header label
    UILabel *header = [UILabel new];
    [header setFont:[UIFont systemFontOfSize:36 weight:UIFontWeightBold]];
    header.text = @"RSSchool";
    
    [self.view addSubview:header];
    header.translatesAutoresizingMaskIntoConstraints = false;
    [header.topAnchor constraintEqualToAnchor:self.view.topAnchor constant: 80].active = true;
    [header.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    
    //MARK: Login field
    self.login = [UITextField new];
    self.login.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.login.autocorrectionType = UITextAutocorrectionTypeNo;
    self.login.placeholder = @"Login";
    self.login.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.login.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_login];
    
    self.login.translatesAutoresizingMaskIntoConstraints = false;
    [self.login.topAnchor constraintEqualToAnchor:header.bottomAnchor constant: 80].active = true;
    [self.login.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant: 36].active = true;
    [self.login.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant: -36].active = true;
    [self.login.heightAnchor constraintEqualToConstant: 34].active = true;
    self.login.layer.cornerRadius = 5;
    self.login.layer.borderWidth = 1.5;
    self.login.layer.borderColor = [UIColor colorNamed: @"BlackCoral"].CGColor;
    
    //MARK: Password field
    self.password = [UITextField new];
    self.password.placeholder = @"Password";
    self.password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.secureTextEntry = YES;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:self.password];
    
    self.password.translatesAutoresizingMaskIntoConstraints = false;
    [self.password.topAnchor constraintEqualToAnchor:self.login.bottomAnchor constant: 30].active = YES;
    [self.password.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant: 36].active = YES;
    [self.password.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant: -36].active = YES;
    [self.password.heightAnchor constraintEqualToConstant: 34].active = YES;
    self.password.layer.cornerRadius = 5;
    self.password.layer.borderWidth = 1.5;
    self.password.layer.borderColor = [UIColor colorNamed: @"BlackCoral"].CGColor;
    
    //MARK: Authorize button
    self.authorize = [HighlightedButton buttonWithType: UIButtonTypeSystem];
    [self.authorize setTitle:@"Authorize" forState: UIControlStateNormal];
    [self.authorize setTitleColor:[UIColor colorNamed: @"LittleBoyBlue"] forState:UIControlStateNormal];
    [self.authorize setTitleColor:[UIColor colorNamed: @"LittleBoyBlue"] forState:UIControlStateDisabled];
    [self.authorize setTitleColor:[UIColor colorNamed: @"LittleBoyBlue"] forState:UIControlStateHighlighted];
    self.authorize.titleLabel.font = [UIFont systemFontOfSize: 20 weight: UIFontWeightSemibold];
    UIImage *person = [UIImage imageNamed: @"Person"];
    UIImage *tintedPerson = [person imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *personFill = [UIImage imageNamed: @"PersonFill"];
    [self.authorize setImage:tintedPerson forState:UIControlStateNormal];
    [self.authorize setImage:personFill forState:UIControlStateHighlighted];
    [self.authorize setImage:tintedPerson forState:UIControlStateDisabled];
    self.authorize.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.authorize setImageEdgeInsets:UIEdgeInsetsMake(13, 13, 13, 13)];
    [self.view addSubview:self.authorize];
    
    self.authorize.translatesAutoresizingMaskIntoConstraints = false;
    [self.authorize.topAnchor constraintEqualToAnchor:self.password.bottomAnchor constant: 60].active = YES;
    [self.authorize.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.authorize.heightAnchor constraintEqualToConstant: 42].active = YES;
    [self.authorize.widthAnchor constraintEqualToConstant: 156].active = YES;
    self.authorize.layer.cornerRadius = 10;
    self.authorize.layer.borderWidth = 2;
    self.authorize.layer.borderColor = [UIColor colorNamed: @"LittleBoyBlue"].CGColor;
    
    //MARK: Secure code view
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 236, 110)];
    [self.view addSubview:_containerView];
    
    self.containerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.containerView.topAnchor constraintEqualToAnchor:self.authorize.bottomAnchor constant: 67].active = true;
    [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.containerView.heightAnchor constraintEqualToConstant: 110].active = YES;
    [self.containerView.widthAnchor constraintEqualToConstant: 236].active = YES;
    self.containerView.layer.borderColor = [UIColor colorNamed:@"VenetianRed"].CGColor;
    self.containerView.layer.cornerRadius = 10;
    
    //MARK: Secure buttons
    for (int i = 0; i < 3; i++) {
        HighlightedButton *secureButton = [HighlightedButton buttonWithType:UIButtonTypeSystem];
        [secureButton setTitle:[@(i+1) stringValue] forState:UIControlStateNormal];
        secureButton.titleLabel.tintColor = [UIColor colorNamed: @"LittleBoyBlue"];
        secureButton.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
        secureButton.tag = i+1;
        
        secureButton.translatesAutoresizingMaskIntoConstraints = false;
        [secureButton.heightAnchor constraintEqualToConstant: 50].active = true;
        [secureButton.widthAnchor constraintEqualToConstant: 50].active = true;
        secureButton.layer.cornerRadius = 25;
        secureButton.layer.borderColor = [UIColor colorNamed:@"LittleBoyBlue"].CGColor;
        secureButton.layer.borderWidth = 2;
        
        [self.secureButtons addObject:secureButton];
    }
    
    UIStackView *stackView = [UIStackView new];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.spacing = 20;
    for (HighlightedButton *button in self.secureButtons) {
        [stackView addArrangedSubview: button];
        [stackView addArrangedSubview: button];
        [stackView addArrangedSubview: button];
    }
    
    [self.containerView addSubview:stackView];
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    [stackView.bottomAnchor constraintEqualToAnchor:_containerView.bottomAnchor constant: -15].active = true;
    [stackView.widthAnchor constraintEqualToConstant: 190].active = true;
    [stackView.heightAnchor constraintEqualToConstant: 50].active = true;
    [stackView.centerXAnchor constraintEqualToAnchor:_containerView.centerXAnchor].active = true;
    
    //MARK: Secure code label
    self.secureCode = [[UILabel alloc] init];
    self.secureCode.font = [UIFont systemFontOfSize: 18 weight: UIFontWeightSemibold];
    [self.containerView addSubview: self.secureCode];
    self.secureCode.translatesAutoresizingMaskIntoConstraints = false;
    [self.secureCode.bottomAnchor constraintEqualToAnchor: stackView.topAnchor constant: -10].active = true;
    [self.secureCode.centerXAnchor constraintEqualToAnchor: self.view.centerXAnchor].active = true;
}

- (void)showAlert {
    UIAlertController *successfulAlert = [UIAlertController
                                          alertControllerWithTitle: @"Welcome"
                                          message: @"You are successfuly authorized!"
                                          preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *refreshAction = [UIAlertAction
                                    actionWithTitle: @"Refresh"
                                    style: UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action) {
        self.login.text = @"";
        self.login.enabled = YES;
        self.login.layer.borderColor = [UIColor colorNamed: @"BlackCoral"].CGColor;
        self.login.alpha = 1;
        self.password.text = @"";
        self.password.enabled = YES;
        self.password.layer.borderColor = [UIColor colorNamed: @"BlackCoral"].CGColor;
        self.password.alpha = 1;
        
        self.authorize.enabled = true;
        self.authorize.alpha = 1;
        
        [self.secureCodeBuffer removeAllObjects];
        [self updateCodeLabel];
        self.containerView.hidden = YES;
        
    }];
    
    [successfulAlert addAction:refreshAction];
    [self showViewController:successfulAlert sender:nil];
}

@end

@interface LoginViewController (TextFieldHandle)
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@implementation LoginViewController (TextFieldHandle)

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = [UIColor colorNamed: @"BlackCoral"].CGColor;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
