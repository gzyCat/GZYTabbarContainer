# GZYTabbarContainer
最近一段时间有时间，将自己整理的文件上传下。该组件模仿仿网易新闻tabbar模式，使用viewCroller的转场动画实现，使用交互式控制动画转场。

使用此方法的优点：
1.每个Controller只处理自己的view就可以，耦合度低。
2.自动控制生命周期，即使在收到内存警告时，系统会自动将不再viewController上自动释放。
3.可以自定义提供其他动画转场效果


参考：
https://www.objc.io/issues/12-animations/custom-container-view-controller-transitions
https://www.iosnomad.com/blog/2014/5/12/interactive-custom-container-view-controller-transitions
