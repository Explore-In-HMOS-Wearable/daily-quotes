import { DailyQuoteModel } from '../model/DailyQuoteModel';
import { DailyQuoteViewModel } from '../viewmodel/DailyQuoteViewModel';
import Preferences from '../common/utils/Preferences';

@Builder
export function QuotePageBuilder() {
  QuotePage()
}

@Entry
@Component
struct QuotePage {
  @State favouriteQuotesIDs: number[] = [];
  @State quoteList: DailyQuoteModel[] = [];
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.getOrUpdatePreferences();
    this.quoteList = this.shuffleArray([...DailyQuoteViewModel.instance.getQuoteList()]);
  }

  shuffleArray(array: DailyQuoteModel[]): DailyQuoteModel[] {
    let currentIndex: number = array.length;
    let randomIndex: number = 0;
    while (currentIndex != 0) {
      randomIndex = Math.floor(Math.random() * currentIndex);
      currentIndex--;
      let temp: DailyQuoteModel = array[currentIndex];
      array[currentIndex] = array[randomIndex];
      array[randomIndex] = temp;
    }
    return array;
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
    NavDestination() {
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
          ForEach(this.quoteList, (item: DailyQuoteModel) => {
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
          }, (item: DailyQuoteModel) => `${item.id}_${item.isFavourite}`)
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
          this.pageInfos.pushPathByName('FavouriteQuotesPage', null)
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