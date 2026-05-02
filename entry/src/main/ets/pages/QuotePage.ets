import { DailyQuoteModel, QuoteCategory } from '../model/DailyQuoteModel';
import { DailyQuoteViewModel } from '../viewmodel/DailyQuoteViewModel';
import { PreferencesModule as Preferences } from '../common/utils/Preferences';

@Builder
export function QuotePageBuilder() {
  QuotePage()
}

@Entry
@Component
struct QuotePage {
  @StorageLink('favouriteQuotesIDs') favouriteQuotesIDs: number[] = [];
  @StorageLink('selectedCategory') selectedCategory: string = 'all';
  @StorageLink('fontSizeSetting') @Watch('onSettingsChange') fontSizeSetting: string = 'medium';
  @StorageLink('isDarkMode') @Watch('onSettingsChange') isDarkMode: boolean = false;
  @State fontSize: number = 14;
  @State bgColor: string = '#fffffbe0';
  @State cardBgColor: string = '#ffefc1a1';
  @State textColour: string = '#ff47392b';
  @State buttonBgColor: string = '#ffcacaca';
  @State filteredQuotes: DailyQuoteModel[] = [];
  pageInfos: NavPathStack = new NavPathStack();

  private categories: string[] = [
    'all',
    QuoteCategory.MOTIVATION,
    QuoteCategory.WISDOM,
    QuoteCategory.LIFE,
    QuoteCategory.SUCCESS,
    QuoteCategory.COURAGE
  ];

  aboutToAppear(): void {
    this.onSettingsChange();
    this.updateFilteredQuotes();
  }

  aboutToDisappear(): void {
    Preferences.instance.off();
  }

  onPageShow(): void {
    this.onSettingsChange();
    this.updateFilteredQuotes();
  }

  onSettingsChange() {
    this.applyFontSize();
    this.applyThemeColors();
  }

  applyFontSize() {
    if (this.fontSizeSetting === 'small') {
      this.fontSize = 12;
    } else if (this.fontSizeSetting === 'large') {
      this.fontSize = 18;
    } else {
      this.fontSize = 14;
    }
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

  isFavouriteQuote(quoteID: number): boolean {
    return this.favouriteQuotesIDs.includes(quoteID);
  }

  async changeQuoteFavourite(quoteID: number): Promise<void> {
    let newIDs: number[];
    if (this.isFavouriteQuote(quoteID)) {
      newIDs = this.favouriteQuotesIDs.filter(id => id !== quoteID);
    } else {
      newIDs = [...this.favouriteQuotesIDs, quoteID];
    }
    await Preferences.instance.putPreference(newIDs);
  }

  updateFilteredQuotes() {
    const allQuotes = DailyQuoteViewModel.instance.getAllQuotes();
    if (this.selectedCategory === 'all') {
      this.filteredQuotes = allQuotes;
    } else {
      this.filteredQuotes = allQuotes.filter(q => q.category === this.selectedCategory);
    }
  }

  build() {
    NavDestination() {
      Column() {
        Button() {
          Text(`Quotes`)
            .fontColor('#ffffffff')
            .fontWeight(900)
            .margin(5)
        }
        .type(ButtonType.Normal)
        .borderRadius(5)
        .backgroundColor('#ff47392b')

        Blank().height('2%')

        Scroll() {
          Row() {
            ForEach(this.categories, (cat: string) => {
              Text(cat.charAt(0).toUpperCase() + cat.slice(1))
                .fontSize(10)
                .fontColor(this.selectedCategory === cat ? '#ffffffff' : this.textColour)
                .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                .margin({ left: 4, right: 4 })
                .borderRadius(5)
                .backgroundColor(this.selectedCategory === cat ? '#ff47392b' : this.buttonBgColor)
                .borderWidth(1)
                .borderColor(this.textColour)
                .onClick(async () => {
                  await Preferences.instance.putSelectedCategory(cat);
                  this.updateFilteredQuotes();
                })
            }, (cat: string) => `${cat}_${this.selectedCategory === cat}`)
          }
          .padding({ left: 10, right: 10 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .width('100%')

        Blank().height('3%')
        
        Swiper() {
          ForEach(this.filteredQuotes, (item: DailyQuoteModel) => {
            Column() {
              Blank()
              Text(item.bodyText)
                .fontColor(this.textColour)
                .fontStyle(FontStyle.Italic)
                .textAlign(TextAlign.Start)
                .fontSize(this.fontSize)
              Text(`- ${item.author}`)
                .textAlign(TextAlign.End)
                .alignSelf(ItemAlign.End)
                .fontColor(this.textColour)
                .fontWeight(900)
                .fontSize(this.fontSize - 2)
              Blank().height('5%')
              Row() {
                Blank().width('3%')
                Button() {
                  Text(this.isFavouriteQuote(item.id) ? 'unfavourite' : 'favourite')
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
                  this.changeQuoteFavourite(item.id);
                })
              }
              .width('100%')
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(this.cardBgColor)
            .borderRadius(20)
            .padding(10)
            .margin({
              left: '10%',
              right: '10%'
            })
            .height('90%')
          }, (item: DailyQuoteModel) => `${item.id}_${this.favouriteQuotesIDs.includes(item.id)}_${this.selectedCategory}`)
        }
        .loop(false)
        .height('50%')
        .width('100%')
        .indicator(false)

        Row() {
          Button() {
            Text('see favorites')
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
            this.pageInfos.pushPathByName('FavouriteQuotesPage', null)
          })
          .padding(10)
          .backgroundColor($r('sys.color.text_button_container_focus_color'))

          Blank().width('5%')

          Button() {
            Text('settings')
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
            this.pageInfos.pushPathByName('SettingsPage', null)
          })
          .padding(10)
          .backgroundColor($r('sys.color.text_button_container_focus_color'))
        }
        .width('90%')
        .justifyContent(FlexAlign.Center)
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
