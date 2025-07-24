import { createClient } from '@supabase/supabase-js';

// Get configuration from window.APP_CONFIG or environment variables
const supabaseUrl = (window as any).APP_CONFIG?.SUPABASE_URL || import.meta.env.VITE_SUPABASE_URL || 'https://qzjmwhjjzlsyppstljcw.supabase.co';
const supabaseAnonKey = (window as any).APP_CONFIG?.SUPABASE_ANON_KEY || import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF6am13aGpqemxzeXBwc3RsamN3Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTc2NDgxMCwiZXhwIjoyMDYxMzQwODEwfQ.y3AE_uo2jXl5iHq1hOA_Kb5LC5Ruc_ff4DUvWD_QsN4';

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    storage: (window as any).APP_CONFIG?.CAPACITOR_ENABLED ? undefined : window?.localStorage,
    storageKey: 'riggerconnect-ios-auth-token',
  },
  global: {
    headers: {
      'X-Client-Platform': 'ios',
      'X-Client-Info': 'RiggerConnect iOS'
    }
  }
});

// Enhanced authentication state management for iOS
export const authStateManager = {
  // Get current session
  async getCurrentSession() {
    const { data: { session }, error } = await supabase.auth.getSession();
    return { session, error };
  },

  // Sign in with email and password
  async signIn(email: string, password: string) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });
    return { data, error };
  },

  // Sign out
  async signOut() {
    const { error } = await supabase.auth.signOut();
    return { error };
  },

  // Listen to auth state changes
  onAuthStateChange(callback: (event: string, session: any) => void) {
    return supabase.auth.onAuthStateChange(callback);
  }
};

export default supabase;
