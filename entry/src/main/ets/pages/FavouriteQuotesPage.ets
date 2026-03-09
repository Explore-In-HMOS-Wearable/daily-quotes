import Preferences from '../common/utils/Preferences';
import { DailyQuoteModel } from '../model/DailyQuoteModel';
import { DailyQuoteViewModel } from '../viewmodel/DailyQuoteViewModel';
import { pasteboard } from '@kit.BasicServicesKit';

@Builder
export function FavouriteQuotesPageBuilder() {
  FavouriteQuotesPage()
}

@Entry
@Component
struct FavouriteQuotesPage {
  favouriteQuotesIDs: number[] = [];
  @State favouriteQuotes: Array<DailyQuoteModel> = [];
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.getFavourites();
  }

  getFavourites() {
    this.favouriteQuotesIDs = Preferences.instance.getPreference();
    this.favouriteQuotes = DailyQuoteViewModel.instance.getFavouriteQuotes(this.favouriteQuotesIDs);
  }

  removeFavouriteQuote(quoteID: number) {
    const index = this.favouriteQuotesIDs.indexOf(quoteID);
    this.favouriteQuotesIDs.splice(index, 1);
    this.favouriteQuotes.splice(index, 1);
    Preferences.instance.putPreference(this.favouriteQuotesIDs);
  }

  build() {
    NavDestination() {
      Column() {
        Button() {
          Text(`Favourites`)
            .fontColor('#fff')
            .fontWeight(900)
            .margin(5)
        }
        .type(ButtonType.Normal)
        .borderRadius(5)
        .backgroundColor('#ff47392b')

        Blank().height('3%')
        if (this.favouriteQuotes.length === 0) {
          Column() {
            Text('No favourites yet')
              .fontColor('#ff47392b')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
          }
          .height('50%')
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        } else {
        Swiper() {
          ForEach(this.favouriteQuotes, (item: DailyQuoteModel) => {
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
                  Text('❤️')
                    .fontSize(18)
                    .fontColor(Color.Black)
                }
                .type(ButtonType.Normal)
                .backgroundColor('#ffcacaca')
                .padding(2)
                .borderRadius(2)
                .borderWidth(1)
                .borderColor(Color.Black)
                .onClick(() => {
                  this.removeFavouriteQuote(item.id);
                })

                Blank().width('3%')

                Button() {
                  Text('copy')
                    .fontSize(14)
                    .fontColor(Color.Black)
                }
                .type(ButtonType.Normal)
                .backgroundColor('#ffcacaca')
                .padding(2)
                .borderRadius(2)
                .borderWidth(1)
                .borderColor(Color.Black)
                .onClick(() => {
                  const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, item.bodyText);
                  pasteboard.getSystemPasteboard().setData(pasteData);
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
          }, (item: DailyQuoteModel) => `${item.id}_${item.isFavourite}`)
        }
        .loop(false)
        .height('50%')
        .width('100%')
        .indicator(false)
        }

        Blank().height('1%')
        Button() {
          Text('see quotes')
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
          this.pageInfos.pop()
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
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
    })
  }
}