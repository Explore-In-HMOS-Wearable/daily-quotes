import { router } from '@kit.ArkUI';


@Entry
@Component
struct Index {

  @State iconAnimation: string = '35%';

  build() {
    Column() {
      Image($r('app.media.ic_splash'))
        .width(this.iconAnimation)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
        .onAppear( () => {
          animateToImmediately({
              duration: 2000,
              curve: Curve.ExtremeDeceleration,
              onFinish: () => {
                router.replaceUrl({
                  url: 'pages/QuotePage'
                })
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
}