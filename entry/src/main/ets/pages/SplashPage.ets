@Entry
@Component
struct Index {

  @State iconAnimation: string = '35%';
  pageStack : NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Column() {
        Image($r('app.media.ic_splash'))
          .height('100%')
          .width(this.iconAnimation)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .onAppear(() => {
            animateToImmediately({
              duration: 2000,
              curve: Curve.ExtremeDeceleration,
              onFinish: () => {
                this.pageStack.pushPathByName('QuotePage', null);
              }
            }, () => {
              this.iconAnimation = '70%'
            })
          })
      }
      .height('100%')
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#fffffbe0')
    }
    .hideTitleBar(true)
  }
}