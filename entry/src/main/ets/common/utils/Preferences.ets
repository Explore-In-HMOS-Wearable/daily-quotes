import preferences from '@ohos.data.preferences';
import { Context, common } from '@kit.AbilityKit';

const PREFERENCES_NAME = 'dailyquotes.db';
let preferencesInstance: preferences.Preferences | null = null;

export interface AppSettings {
  fontSize: string;
  themeMode: string;
  selectedCategory: string;
}

class PreferencesManager {
  private initialized: boolean = false;

  initialize(context: Context | common.Context): void {
    if (context && !preferencesInstance) {
      try {
        preferencesInstance = preferences.getPreferencesSync(context, { name: PREFERENCES_NAME });
        this.initialized = true;
        console.info('[initialize] Preferences initialized');
      } catch (err) {
        console.error(`[initialize] ${err.code} ${err.message}`);
      }
    }
  }

  async loadToAppStorage(): Promise<void> {
    if (!preferencesInstance) return;
    try {
      const fontSize = await preferencesInstance.get('fontSize', 'medium') as preferences.ValueType as string;
      const themeMode = await preferencesInstance.get('themeMode', 'light') as preferences.ValueType as string;
      const favourites = await preferencesInstance.get('favourites', []) as preferences.ValueType as number[];
      const selectedCategory = await preferencesInstance.get('selectedCategory', 'all') as preferences.ValueType as string | null;

      AppStorage.setOrCreate('fontSizeSetting', fontSize);
      AppStorage.setOrCreate('themeModeSetting', themeMode);
      AppStorage.setOrCreate('isDarkMode', themeMode === 'dark');
      AppStorage.setOrCreate('favouriteQuotesIDs', favourites);
      AppStorage.setOrCreate('selectedCategory', selectedCategory);
    } catch (err) {
      console.error(`[loadToAppStorage] ${err.code} ${err.message}`);
    }
  }

  on(callback: Callback<Record<string, preferences.ValueType>>): void {
    if (preferencesInstance) preferencesInstance.on('dataChange', ['favourites'], callback);
  }

  off(): void {
    if (preferencesInstance) preferencesInstance.off('dataChange', ['favourites']);
  }

  async putPreference(data: number[]): Promise<void> {
    if (!preferencesInstance) return;
    try {
      await preferencesInstance.put('favourites', data);
      await preferencesInstance.flush();
      AppStorage.setOrCreate('favouriteQuotesIDs', data);
    } catch (err) {
      console.error(`[putPreference] ${err.code} ${err.message}`);
    }
  }

  async getPreference(): Promise<number[]> {
    if (!preferencesInstance) return [];
    try {
      return await preferencesInstance.get('favourites', []) as preferences.ValueType as number[];
    } catch (err) {
      console.error(`[getPreference] ${err.code} ${err.message}`);
      return [];
    }
  }

  async putSettings(settings: AppSettings): Promise<void> {
    if (!preferencesInstance) return;
    try {
      await preferencesInstance.put('fontSize', settings.fontSize);
      await preferencesInstance.put('themeMode', settings.themeMode);
      await preferencesInstance.flush();
      AppStorage.setOrCreate('fontSizeSetting', settings.fontSize);
      AppStorage.setOrCreate('themeModeSetting', settings.themeMode);
      AppStorage.setOrCreate('isDarkMode', settings.themeMode === 'dark');
    } catch (err) {
      console.error(`[putSettings] ${err.code} ${err.message}`);
    }
  }

  async getSettings(): Promise<AppSettings | null> {
    if (!preferencesInstance) return null;
    try {
      const fontSize = await preferencesInstance.get('fontSize', 'medium') as preferences.ValueType as string;
      const themeMode = await preferencesInstance.get('themeMode', 'light') as preferences.ValueType as string;
      const selectedCategory = await preferencesInstance.get('selectedCategory', 'all') as preferences.ValueType as string;
      return { fontSize, themeMode, selectedCategory };
    } catch (err) {
      console.error(`[getSettings] ${err.code} ${err.message}`);
      return null;
    }
  }

  async putSelectedCategory(category: string | null): Promise<void> {
    if (!preferencesInstance) {
      console.error('[putSelectedCategory] preferencesInstance is null');
      return;
    }
    try {
      AppStorage.setOrCreate('selectedCategory', category);
      await preferencesInstance.put('selectedCategory', category);
      await preferencesInstance.flush();
    } catch (err) {
      console.error(`[putSelectedCategory] ${err.code} ${err.message}`);
    }
  }

  async getSelectedCategory(): Promise<string> {
    if (!preferencesInstance) return 'all';
    try {
      const val = await preferencesInstance.get('selectedCategory', 'all');
      return val !== null ? (val as preferences.ValueType as string) : 'all';
    } catch (err) {
      console.error(`[getSelectedCategory] ${err.code} ${err.message}`);
      return 'all';
    }
  }
}

let prefsInstance: PreferencesManager | null = null;

export class PreferencesModule {
  static getInstance(context: Context | common.Context): PreferencesManager {
    if (!prefsInstance) prefsInstance = new PreferencesManager();
    prefsInstance.initialize(context);
    return prefsInstance;
  }

  static get instance(): PreferencesManager {
    if (!prefsInstance) prefsInstance = new PreferencesManager();
    if (!preferencesInstance) {
      const context = AppStorage.get<common.Context>('context');
      if (context) prefsInstance.initialize(context);
    }
    return prefsInstance;
  }
}
