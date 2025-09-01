import { DailyQuoteModel } from '../model/DailyQuoteModel';
import { DailyQuoteViewModel } from '../viewmodel/DailyQuoteViewModel';
import { router } from '@kit.ArkUI';
import Preferences from '../common/utils/Preferences';


@Entry
@Component
struct QuotePage {
  @State favouriteQuotesIDs: number[] = [];

  aboutToAppear(): void {
    this.getOrUpdatePreferences();
  }

  aboutToDisappear(): void {
    Preferences.instance.off();
  }

  onPageShow(): void {
    this.getOrUpdatePreferences();
  }

  getOrUpdatePreferences() {
    this.favouriteQuotesIDs = Preferences.instance.getPreference();
  }

  isFavouriteQuote(quoteID: number): boolean {
    return this.favouriteQuotesIDs.includes(quoteID);
  }

  changeQuoteFavourite(quoteID: number) {
    if (this.isFavouriteQuote(quoteID)) {
      const index = this.favouriteQuotesIDs.indexOf(quoteID);
      this.favouriteQuotesIDs.splice(index, 1);
    } else {
      this.favouriteQuotesIDs.push(quoteID);
    }
    Preferences.instance.putPreference(this.favouriteQuotesIDs);
  }

  build() {
    Column() {
      Button() {
        Text(`Quotes`)
          .fontColor('#fff')
          .fontWeight(900)
          .margin(5)
      }
      .type(ButtonType.Normal)
      .borderRadius(5)
      .backgroundColor('#ff47392b')

      Blank().height('3%')
      Swiper() {
        ForEach(DailyQuoteViewModel.instance.getQuoteList(), (item: DailyQuoteModel, index: number) => {
          Column() {
            Blank()
            Text(item.bodyText)
              .fontColor('#ff47392b')
              .fontStyle(FontStyle.Italic)
              .textAlign(TextAlign.Start)
            Text(`- ${item.author}`)
              .fontColor(Color.Blue)
              .textAlign(TextAlign.End)
              .alignSelf(ItemAlign.End)
              .fontColor('#ff47392b')
              .fontWeight(900)
            Blank().height('5%')
            Row() {
              Blank().width('3%')
              Button() {
                Text(this.isFavouriteQuote(item.id) ? 'unfavourite' : 'favourite')
                  .fontSize(11)
                  .fontStyle(FontStyle.Italic)
                  .fontColor(Color.Black)
              }
              .type(ButtonType.Normal)
              .backgroundColor('#ffcacaca')
              .padding(2)
              .borderRadius(2)
              .borderWidth(1)
              .borderColor(Color.Black)
              .onClick(() => {
                this.changeQuoteFavourite(item.id);
              })
            }
            .width('100%')
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#ffefc1a1')
          .borderRadius(20)
          .padding(5)
          .margin({
            left: '10%',
            right: '10%'
          })
        }, (index: number) => index.toString())
      }
      .loop(false)
      .height('50%')
      .width('100%')
      .indicator(false)

      Blank().height('1%')
      Button() {
        Text('see favorites')
          .fontSize(11)
          .fontStyle(FontStyle.Italic)
          .fontColor('#ff47392b')
          .decoration({
            type: TextDecorationType.Underline,
            color: '#ff47392b',
            style: TextDecorationStyle.SOLID
          })
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/FavouriteQuotesPage'
        })
      })
      .padding(10)
      .backgroundColor($r('sys.color.text_button_container_focus_color'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#fffffbe0')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}