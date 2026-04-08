import { DailyQuoteModel, QuoteCategory } from '../model/DailyQuoteModel';
import { PreferencesModule as Preferences } from '../common/utils/Preferences';
import { common } from '@kit.AbilityKit';

export function initializePreferences(context: common.Context): void {
  Preferences.getInstance(context);
}

@Observed
export class DailyQuoteViewModel {
  static instance = new DailyQuoteViewModel();
  selectedCategory: QuoteCategory | null = null;

  constructor() {
    this.loadCategoryFromStorage();
  }

  private async loadCategoryFromStorage(): Promise<void> {
    const prefs = Preferences.instance;
    if (prefs) {
      const savedCategory = await prefs.getSelectedCategory();
      if (savedCategory) {
        this.selectedCategory = savedCategory as QuoteCategory;
      }
    }
  }

  private async saveCategoryToStorage(): Promise<void> {
    const prefs = Preferences.instance;
    if (prefs) {
      await prefs.putSelectedCategory(this.selectedCategory);
    }
  }

  getQuoteList(): Array<DailyQuoteModel> {
    if (this.selectedCategory) {
      return DAILY_QUOTE_DATA.filter((quote) => quote.category === this.selectedCategory);
    }
    return DAILY_QUOTE_DATA;
  }

  getAllQuotes(): Array<DailyQuoteModel> {
    return DAILY_QUOTE_DATA;
  }

  getDailyQuote(): Array<DailyQuoteModel> {
    let today = new Date();
    let dayIndex = today.getDay();
    return [DAILY_QUOTE_DATA[dayIndex]]
  }

  getFavouriteQuotes(favouriteQuoteIDs: Array<number>): Array<DailyQuoteModel> {
    return DAILY_QUOTE_DATA.filter((quote) => favouriteQuoteIDs.indexOf(quote.id) !== -1);
  }

  getCategories(): Array<QuoteCategory> {
    return [
      QuoteCategory.MOTIVATION,
      QuoteCategory.WISDOM,
      QuoteCategory.LIFE,
      QuoteCategory.SUCCESS,
      QuoteCategory.COURAGE
    ];
  }

  setCategory(category: QuoteCategory | null): void {
    this.selectedCategory = category;
    this.saveCategoryToStorage();
  }
}

const DAILY_QUOTE_DATA: Array<DailyQuoteModel> = [
  new DailyQuoteModel(
    1,
    `If you can dream it, you can do it`,
    `Walt Disney`,
    QuoteCategory.MOTIVATION,
  ),
  new DailyQuoteModel(
    2,
    `The journey of a thousand miles begins with one step`,
    `Lao Tzu`,
    QuoteCategory.MOTIVATION,
  ),
  new DailyQuoteModel(
    3,
    `The road to success and the road to failure are almost exactly the same`,
    `Colin R. Davis`,
    QuoteCategory.WISDOM,
  ),
  new DailyQuoteModel(
    4,
    `Don't let yesterday take up too much of today`,
    `Will Rogers`,
    QuoteCategory.LIFE,
  ),
  new DailyQuoteModel(
    5,
    `He who conquers himself is the mightiest warrior`,
    `Confucius`,
    QuoteCategory.COURAGE,
  ),
  new DailyQuoteModel(
    6,
    `The only thing necessary for the triumph of evil is for good men to do nothing`,
    `Edmund Burke`,
    QuoteCategory.WISDOM,
  ),
  new DailyQuoteModel(
    7,
    `I have not failed. I've just found 10,000 ways that won't work`,
    `Thomas A. Edison`,
    QuoteCategory.SUCCESS,
  )
];