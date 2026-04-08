import { PreferencesModule as Preferences } from '../common/utils/Preferences';
import { DailyQuoteModel } from '../model/DailyQuoteModel';
import { DailyQuoteViewModel } from '../viewmodel/DailyQuoteViewModel';

@Builder
export function FavouriteQuotesPageBuilder() {
  FavouriteQuotesPage()
}

@Entry
@Component
struct FavouriteQuotesPage {
  @StorageLink('favouriteQuotesIDs') @Watch('getFavourites') favouriteQuotesIDs: number[] = [];
  @State favouriteQuotes: Array<DailyQuoteModel> = [];
  @StorageLink('isDarkMode') @Watch('onSettingsChange') isDarkMode: boolean = false;
  @State bgColor: string = '#fffffbe0';
  @State cardBgColor: string = '#ffefc1a1';
  @State textColour: string = '#ff47392b';
  @State buttonBgColor: string = '#ffcacaca';
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.getFavourites();
    this.onSettingsChange();
  }

  onPageShow(): void {
    this.getFavourites();
    this.onSettingsChange();
  }

  onSettingsChange() {
    this.applyThemeColors();
  }

  applyThemeColors() {
    if (this.isDarkMode) {
      this.bgColor = '#ff1a1a1a';
      this.cardBgColor = '#ff2d2d2d';
      this.textColour = '#ffffffff';
      this.buttonBgColor = '#ff3d3d3d';
    } else {
      this.bgColor = '#fffffbe0';
      this.cardBgColor = '#ffefc1a1';
      this.textColour = '#ff47392b';
      this.buttonBgColor = '#ffcacaca';
    }
  }

  getFavourites() {
    this.favouriteQuotes = DailyQuoteViewModel.instance.getFavouriteQuotes(this.favouriteQuotesIDs);
  }

  async removeFavouriteQuote(quoteID: number): Promise<void> {
    this.favouriteQuotesIDs = this.favouriteQuotesIDs.filter(id => id !== quoteID);
    await Preferences.instance.putPreference(this.favouriteQuotesIDs);
  }

  build() {
    NavDestination() {
      Column() {
        Button() {
          Text(`Favourites`)
            .fontColor(Color.White)
            .fontWeight(900)
            .margin(5)
        }
        .type(ButtonType.Normal)
        .borderRadius(5)
        .backgroundColor('#ff47392b')

        Blank().height('3%')
        Swiper() {
          ForEach(this.favouriteQuotes, (item: DailyQuoteModel) => {
            Column() {
              Blank()
              Text(item.bodyText)
                .fontColor(this.textColour)
                .fontStyle(FontStyle.Italic)
                .textAlign(TextAlign.Start)
              Text(`- ${item.author}`)
                .fontColor(Color.Blue)
                .textAlign(TextAlign.End)
                .alignSelf(ItemAlign.End)
                .fontColor(this.textColour)
                .fontWeight(900)
              Blank().height('5%')
              Row() {
                Blank().width('3%')
                Button() {
                  Text('unfavourite')
                    .fontSize(11)
                    .fontStyle(FontStyle.Italic)
                    .fontColor(this.textColour)
                }
                .type(ButtonType.Normal)
                .backgroundColor(this.buttonBgColor)
                .padding(2)
                .borderRadius(2)
                .borderWidth(1)
                .borderColor(this.textColour)
                .onClick(() => {
                  this.removeFavouriteQuote(item.id);
                })
              }
              .width('100%')
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.cardBgColor)
            .borderRadius(20)
            .padding(5)
            .margin({
              left: '10%',
              right: '10%'
            })
          }, (item: DailyQuoteModel) => `${item.id}_true`)
        }
        .loop(false)
        .height('50%')
        .width('100%')
        .indicator(false)

        Blank().height('1%')
        Button() {
          Text('see quotes')
            .fontSize(11)
            .fontStyle(FontStyle.Italic)
            .fontColor(this.textColour)
            .decoration({
              type: TextDecorationType.Underline,
              color: this.textColour,
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
      .backgroundColor(this.bgColor)
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
