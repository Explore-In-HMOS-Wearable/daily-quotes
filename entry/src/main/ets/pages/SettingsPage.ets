import { PreferencesModule as Preferences, AppSettings } from '../common/utils/Preferences';

enum FontSize {
  SMALL = 'small',
  MEDIUM = 'medium',
  LARGE = 'large'
}

enum ThemeMode {
  LIGHT = 'light',
  DARK = 'dark'
}

@Builder
export function SettingsPageBuilder() {
  SettingsPage()
}

@Entry
@Component
struct SettingsPage {
  @StorageLink('fontSizeSetting') fontSizeSetting: string = FontSize.MEDIUM;
  @StorageLink('themeModeSetting') themeModeSetting: string = ThemeMode.LIGHT;
  @StorageLink('isDarkMode') isDarkMode: boolean = false;
  @State bgColor: string = '#fffffbe0';
  @State textColour: string = '#ff47392b';
  @State buttonBgColor: string = '#ffcacaca';
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.applyThemeColors();
  }

  onPageShow(): void {
    this.applyThemeColors();
  }

  applyThemeColors() {
    if (this.isDarkMode) {
      this.bgColor = '#ff1a1a1a';
      this.textColour = '#ffffffff';
      this.buttonBgColor = '#ff3d3d3d';
    } else {
      this.bgColor = '#fffffbe0';
      this.textColour = '#ff47392b';
      this.buttonBgColor = '#ffcacaca';
    }
  }

  async setFontSize(size: string): Promise<void> {
    this.fontSizeSetting = size;
    await this.saveSettings();
  }

  async setThemeMode(mode: string): Promise<void> {
    this.themeModeSetting = mode;
    this.isDarkMode = mode === 'dark';
    this.applyThemeColors();
    await this.saveSettings();
  }

  async saveSettings(): Promise<void> {
    const settings: AppSettings = {
      fontSize: this.fontSizeSetting,
      themeMode: this.themeModeSetting,
      selectedCategory: AppStorage.get<string>('selectedCategoryPersistent') || 'all'
    };
    await Preferences.instance.putSettings(settings);
  }

  getFontSizeValue(): number {
    switch (this.fontSizeSetting) {
      case FontSize.SMALL:
        return 12;
      case FontSize.LARGE:
        return 18;
      default:
        return 14;
    }
  }

  build() {
    NavDestination() {
      Column() {
        Button() {
          Text(`Settings`)
            .fontColor(Color.White)
            .fontWeight(900)
            .margin(5)
        }
        .type(ButtonType.Normal)
        .borderRadius(5)
        .backgroundColor('#ff47392b')

        Blank().height('5%')

        Column() {
          Text('Font Size')
            .fontSize(12)
            .fontColor(this.textColour)
            .fontWeight(600)

          Blank().height('3%')
          Row() {
            ForEach([FontSize.SMALL, FontSize.MEDIUM, FontSize.LARGE], (size: string) => {
              Text(size.charAt(0).toUpperCase() + size.slice(1))
                .fontSize(10)
                .fontColor(this.fontSizeSetting === size ? '#ffffffff' : this.textColour)
                .padding(4)
                .borderRadius(3)
                .backgroundColor(this.fontSizeSetting === size ? '#ff47392b' : this.buttonBgColor)
                .borderWidth(1)
                .borderColor(this.textColour)
                .onClick(() => {
                  this.setFontSize(size);
                })
            }, (size: string) => size)
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceAround)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Blank().height('5%')

        Column() {
          Text('Theme')
            .fontSize(12)
            .fontColor(this.textColour)
            .fontWeight(600)

          Blank().height('3%')
          Row() {
            ForEach([ThemeMode.LIGHT, ThemeMode.DARK], (mode: string) => {
              Text(mode.charAt(0).toUpperCase() + mode.slice(1))
                .fontSize(10)
                .fontColor(this.themeModeSetting === mode ? '#ffffffff' : this.textColour)
                .padding(4)
                .borderRadius(3)
                .backgroundColor(this.themeModeSetting === mode ? '#ff47392b' : this.buttonBgColor)
                .borderWidth(1)
                .borderColor(this.textColour)
                .onClick(() => {
                  this.setThemeMode(mode);
                })
            }, (mode: string) => mode)
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceAround)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)

        Blank().height('10%')

        Button() {
          Text('Back to Quotes')
            .fontSize(11)
            .fontStyle(FontStyle.Italic)
            .fontColor(this.textColour)
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
