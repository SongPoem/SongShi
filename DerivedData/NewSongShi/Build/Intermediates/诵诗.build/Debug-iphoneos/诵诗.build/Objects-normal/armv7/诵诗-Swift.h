// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import UIKit;
@import CoreGraphics;
@import Speech;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class UIWindow;
@class UIApplication;

SWIFT_CLASS("_TtC6诵诗11AppDelegate")
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow * _Nullable window;
- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> * _Nullable)launchOptions;
- (void)applicationWillResignActive:(UIApplication * _Nonnull)application;
- (void)applicationDidEnterBackground:(UIApplication * _Nonnull)application;
- (void)applicationWillEnterForeground:(UIApplication * _Nonnull)application;
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;
- (void)applicationWillTerminate:(UIApplication * _Nonnull)application;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIPageControl;
@class UIButton;
@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC6诵诗19GuideViewController")
@interface GuideViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIPageControl * _Null_unspecified pageControl;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified startButton;
- (void)viewDidLoad;
@property (nonatomic, readonly) BOOL prefersStatusBarHidden;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UIScrollView;

@interface GuideViewController (SWIFT_EXTENSION(诵诗)) <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView * _Nonnull)scrollView;
- (void)jumpTo;
@end

@class UIImageView;

SWIFT_CLASS("_TtC6诵诗20LevelsViewController")
@interface LevelsViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified springSwitcher;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified summerSwitcher;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified autumnSwitcher;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified winterSwitcher;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified sub;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified first;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified second;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified third;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified lock1;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified lock2;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified lock3;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified switching2;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified switching1;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidLoad;
- (IBAction)switchToSingleView:(UIButton * _Nonnull)sender;
- (void)initButtonWithButton:(UIButton * _Nonnull)button width:(CGFloat)width height:(CGFloat)height name:(NSString * _Nonnull)name SWIFT_METHOD_FAMILY(none);
- (void)enableButtons;
- (void)adjustLockedWithA:(CGFloat)a b:(CGFloat)b c:(CGFloat)c;
- (BOOL)translateWithM:(CGFloat)m;
- (void)bulidArr;
- (void)switchImagesWithA:(NSString * _Nonnull)a b:(NSString * _Nonnull)b c:(NSString * _Nonnull)c;
- (void)adjustBGWithBG:(UIImageView * _Nonnull)BG;
- (void)BGSwitch;
- (IBAction)switchLevels:(UIButton * _Nonnull)sender;
- (IBAction)switchSubview:(UIButton * _Nonnull)sender;
- (void)switchIcons;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC6诵诗14ViewController")
@interface ViewController : UIViewController
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UILabel;
@class UITextView;

SWIFT_CLASS("_TtC6诵诗21explainViewController")
@interface explainViewController : UIViewController
@property (nonatomic, readonly, strong) UILabel * _Nonnull poemName;
@property (nonatomic, readonly, strong) UILabel * _Nonnull poet;
@property (nonatomic, readonly, strong) UITextView * _Nonnull poem;
@property (nonatomic, copy) NSString * _Nonnull poemText;
@property (nonatomic) void * _Nullable stmt;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified poetry;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified explanation;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified translation;
@property (nonatomic, weak) IBOutlet UIButton * _Null_unspecified backToMenu;
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified maskView;
- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)poemIntegrate;
- (void)setPoemTitle;
- (void)setPoet;
- (void)setPoem;
- (void)getStatement;
- (IBAction)getPoemText:(id _Nonnull)sender;
- (IBAction)getPoemExplanation:(id _Nonnull)sender;
- (IBAction)getPoemTramslation:(id _Nonnull)sender;
- (void)jumpTo;
- (void)initBackground SWIFT_METHOD_FAMILY(none);
- (void)setMask;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class UITextField;
@class UIView;
@class UITapGestureRecognizer;
@class UISwipeGestureRecognizer;

SWIFT_CLASS("_TtC6诵诗20singleViewController")
@interface singleViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, SFSpeechRecognizerDelegate, UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView * _Null_unspecified backgroundPic;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) void * _Nullable db;)
+ (void * _Nullable)db;
+ (void)setDb:(void * _Nullable)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) void * _Nullable stmt;)
+ (void * _Nullable)stmt;
+ (void)setStmt:(void * _Nullable)value;
@property (nonatomic, copy) NSString * _Nullable blank;
@property (nonatomic, copy) NSString * _Nullable fillIn;
@property (nonatomic, readonly, strong) UITextField * _Nonnull inputText;
@property (nonatomic) NSInteger addition;
@property (nonatomic, copy) NSString * _Nullable userpoem;
@property (nonatomic) BOOL Issuccess;
@property (nonatomic) BOOL nexton;
@property (nonatomic, copy) NSString * _Nonnull dbname;
@property (nonatomic) CGFloat locate;
@property (nonatomic) NSInteger blankNum;
@property (nonatomic) NSInteger sentenceCount;
@property (nonatomic) NSInteger sentenceNum;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly) CGFloat width;)
+ (CGFloat)width;
@property (nonatomic, readonly, copy) NSArray<NSArray<NSNumber *> *> * _Nonnull positionX;
@property (nonatomic, copy) NSArray<UILabel *> * _Nonnull poemlabel;
@property (nonatomic, readonly, copy) NSString * _Nonnull blankFrame;
@property (nonatomic, readonly, strong) UIButton * _Nonnull readButton;
@property (nonatomic) BOOL ifClickRecord;
@property (nonatomic) NSInteger levelNum;
@property (nonatomic, readonly, strong) UIButton * _Nonnull checkButton;
@property (nonatomic) BOOL signOfSuccessDidAppear;
- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
- (void)initBackground SWIFT_METHOD_FAMILY(none);
- (void)initSpeech SWIFT_METHOD_FAMILY(none);
- (void)initLabel SWIFT_METHOD_FAMILY(none);
- (void)addConstraintsWithLine:(UIView * _Nonnull)line;
- (void)addConstraintsNaWithLine:(UIView * _Nonnull)line;
- (NSInteger)blankIDWithLineLimit:(NSInteger)lineLimit;
- (void)keyboardDisappearWithTap:(UITapGestureRecognizer * _Nonnull)tap;
- (void)initInputText SWIFT_METHOD_FAMILY(none);
- (BOOL)textFieldShouldReturn:(UITextField * _Nonnull)textField;
- (void)keyboardAppearWithTap:(UITapGestureRecognizer * _Nonnull)tap;
- (void)initButtonWithPositionX:(CGFloat)positionX SWIFT_METHOD_FAMILY(none);
- (void)record;
+ (void)openDB;
- (void)operateQuery;
- (void)startRecording;
- (void)initCheckButton SWIFT_METHOD_FAMILY(none);
- (void)checkIfRight;
- (void)switchToNextPoemWithSlide:(UISwipeGestureRecognizer * _Nonnull)slide;
- (void)resumeLevel;
- (BOOL)checklikeWithStrread:(NSString * _Nonnull)strread strpoem:(NSString * _Nonnull)strpoem;
- (void)poemname;
- (void)jumpTo;
- (void)readcheck;
- (void)initable SWIFT_METHOD_FAMILY(none);
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
