export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      achievements: {
        Row: {
          created_at: string
          id: string
          name: string
          type: string
          user: string
        }
        Insert: {
          created_at?: string
          id?: string
          name: string
          type: string
          user: string
        }
        Update: {
          created_at?: string
          id?: string
          name?: string
          type?: string
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "achievements_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "achievements_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "achievements_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "achievements_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      car_aliases: {
        Row: {
          alias_make: string
          alias_model: string
          canonical_make: string
          canonical_model: string
          car_id: string
          created_at: string | null
          id: string
        }
        Insert: {
          alias_make: string
          alias_model: string
          canonical_make: string
          canonical_model: string
          car_id: string
          created_at?: string | null
          id?: string
        }
        Update: {
          alias_make?: string
          alias_model?: string
          canonical_make?: string
          canonical_model?: string
          car_id?: string
          created_at?: string | null
          id?: string
        }
        Relationships: [
          {
            foreignKeyName: "car_aliases_car_id_fkey"
            columns: ["car_id"]
            isOneToOne: false
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
        ]
      }
      car_history: {
        Row: {
          car: string
          designer_name: string | null
          fun_facts: string[] | null
          heritage: string | null
          significance: string | null
        }
        Insert: {
          car: string
          designer_name?: string | null
          fun_facts?: string[] | null
          heritage?: string | null
          significance?: string | null
        }
        Update: {
          car?: string
          designer_name?: string | null
          fun_facts?: string[] | null
          heritage?: string | null
          significance?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "car_history_car_fkey"
            columns: ["car"]
            isOneToOne: true
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
        ]
      }
      car_makes: {
        Row: {
          created_at: string
          id: string
          logo_url: string
          name: string
        }
        Insert: {
          created_at?: string
          id?: string
          logo_url: string
          name: string
        }
        Update: {
          created_at?: string
          id?: string
          logo_url?: string
          name?: string
        }
        Relationships: []
      }
      car_match_logs: {
        Row: {
          car: string | null
          confidence_score: number | null
          created_at: string | null
          id: string
          is_borderline: boolean | null
          make_similarity: number | null
          match_type: string
          metadata: Json | null
          model_similarity: number | null
          normalized_color: string
          normalized_make: string
          normalized_model: string
          normalized_year: string
          raw_color: string
          raw_make: string
          raw_model: string
          raw_year: string
          user_id: string
        }
        Insert: {
          car?: string | null
          confidence_score?: number | null
          created_at?: string | null
          id?: string
          is_borderline?: boolean | null
          make_similarity?: number | null
          match_type: string
          metadata?: Json | null
          model_similarity?: number | null
          normalized_color: string
          normalized_make: string
          normalized_model: string
          normalized_year: string
          raw_color: string
          raw_make: string
          raw_model: string
          raw_year: string
          user_id: string
        }
        Update: {
          car?: string | null
          confidence_score?: number | null
          created_at?: string | null
          id?: string
          is_borderline?: boolean | null
          make_similarity?: number | null
          match_type?: string
          metadata?: Json | null
          model_similarity?: number | null
          normalized_color?: string
          normalized_make?: string
          normalized_model?: string
          normalized_year?: string
          raw_color?: string
          raw_make?: string
          raw_model?: string
          raw_year?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "car_match_logs_car_fkey"
            columns: ["car"]
            isOneToOne: false
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
        ]
      }
      car_production: {
        Row: {
          car: string
          circulation_count: number | null
          description: string | null
          max_value: number | null
          min_value: number | null
          msrp: number | null
          total_made: number | null
          year_end: number | null
          year_start: number | null
        }
        Insert: {
          car: string
          circulation_count?: number | null
          description?: string | null
          max_value?: number | null
          min_value?: number | null
          msrp?: number | null
          total_made?: number | null
          year_end?: number | null
          year_start?: number | null
        }
        Update: {
          car?: string
          circulation_count?: number | null
          description?: string | null
          max_value?: number | null
          min_value?: number | null
          msrp?: number | null
          total_made?: number | null
          year_end?: number | null
          year_start?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "car_production_car_fkey"
            columns: ["car"]
            isOneToOne: true
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
        ]
      }
      car_specs: {
        Row: {
          acceleration_0_100: number | null
          car: string
          configuration: string | null
          displacement_l: number | null
          power_kw: number | null
          quarter_mile_s: number | null
          top_speed_kmh: number | null
          torque_nm: number | null
          weight_kg: number | null
        }
        Insert: {
          acceleration_0_100?: number | null
          car: string
          configuration?: string | null
          displacement_l?: number | null
          power_kw?: number | null
          quarter_mile_s?: number | null
          top_speed_kmh?: number | null
          torque_nm?: number | null
          weight_kg?: number | null
        }
        Update: {
          acceleration_0_100?: number | null
          car?: string
          configuration?: string | null
          displacement_l?: number | null
          power_kw?: number | null
          quarter_mile_s?: number | null
          top_speed_kmh?: number | null
          torque_nm?: number | null
          weight_kg?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "car_specs_car_fkey"
            columns: ["car"]
            isOneToOne: true
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
        ]
      }
      car_spots: {
        Row: {
          address: string
          car: string
          created_at: string
          face_detected: boolean
          id: string
          image_url: string
          is_claimed: boolean
          is_flagged: boolean
          is_manual: boolean
          lat_lng: unknown
          location: Json | null
          number_plate: string | null
          user: string
        }
        Insert: {
          address?: string
          car: string
          created_at?: string
          face_detected?: boolean
          id?: string
          image_url: string
          is_claimed?: boolean
          is_flagged?: boolean
          is_manual?: boolean
          lat_lng?: unknown
          location?: Json | null
          number_plate?: string | null
          user: string
        }
        Update: {
          address?: string
          car?: string
          created_at?: string
          face_detected?: boolean
          id?: string
          image_url?: string
          is_claimed?: boolean
          is_flagged?: boolean
          is_manual?: boolean
          lat_lng?: unknown
          location?: Json | null
          number_plate?: string | null
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "car_spots_car_fkey"
            columns: ["car"]
            isOneToOne: false
            referencedRelation: "cars"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      cars: {
        Row: {
          created_at: string
          description: string | null
          id: string
          make: string
          model: string
          points: number
          rarity: Database["public"]["Enums"]["rarity"]
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          make: string
          model: string
          points: number
          rarity: Database["public"]["Enums"]["rarity"]
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          make?: string
          model?: string
          points?: number
          rarity?: Database["public"]["Enums"]["rarity"]
        }
        Relationships: [
          {
            foreignKeyName: "cars_make_fkey"
            columns: ["make"]
            isOneToOne: false
            referencedRelation: "car_makes"
            referencedColumns: ["id"]
          },
        ]
      }
      flagged_car_spots: {
        Row: {
          car_spot: string
          comments: string | null
          created_at: string
          id: string
          reason: string
          user: string
        }
        Insert: {
          car_spot: string
          comments?: string | null
          created_at?: string
          id?: string
          reason: string
          user: string
        }
        Update: {
          car_spot?: string
          comments?: string | null
          created_at?: string
          id?: string
          reason?: string
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "flagged_car_spots_car_spot_fkey"
            columns: ["car_spot"]
            isOneToOne: false
            referencedRelation: "car_spots"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "flagged_car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "flagged_car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "flagged_car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "flagged_car_spots_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      subscription_events: {
        Row: {
          created_at: string
          id: string
          payload: Json | null
          type: string | null
          user: string | null
        }
        Insert: {
          created_at?: string
          id: string
          payload?: Json | null
          type?: string | null
          user?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          payload?: Json | null
          type?: string | null
          user?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "subscription_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "subscription_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscription_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscription_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      subscriptions: {
        Row: {
          cancel_reason: string | null
          country_code: string | null
          created_at: string
          entitlement_ids: string[]
          is_trial_conversion: boolean
          latest_transaction_id: string | null
          offer_code: string | null
          original_transaction_id: string | null
          period_type: string | null
          product_id: string
          store: string | null
          subscriber_attributes: Json | null
          user: string
        }
        Insert: {
          cancel_reason?: string | null
          country_code?: string | null
          created_at?: string
          entitlement_ids: string[]
          is_trial_conversion?: boolean
          latest_transaction_id?: string | null
          offer_code?: string | null
          original_transaction_id?: string | null
          period_type?: string | null
          product_id: string
          store?: string | null
          subscriber_attributes?: Json | null
          user: string
        }
        Update: {
          cancel_reason?: string | null
          country_code?: string | null
          created_at?: string
          entitlement_ids?: string[]
          is_trial_conversion?: boolean
          latest_transaction_id?: string | null
          offer_code?: string | null
          original_transaction_id?: string | null
          period_type?: string | null
          product_id?: string
          store?: string | null
          subscriber_attributes?: Json | null
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscriptions_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "subscriptions_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscriptions_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscriptions_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      user_following: {
        Row: {
          created_at: string
          followed_user: string
          user: string
        }
        Insert: {
          created_at?: string
          followed_user: string
          user: string
        }
        Update: {
          created_at?: string
          followed_user?: string
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_following_followed_user_fkey"
            columns: ["followed_user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "user_following_followed_user_fkey"
            columns: ["followed_user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_following_followed_user_fkey"
            columns: ["followed_user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_following_followed_user_fkey"
            columns: ["followed_user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "user_following_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "user_following_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_following_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_following_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      user_stats: {
        Row: {
          legendary_spots: number
          level: number
          spotting_streak: number
          total_spots: number
          total_xp: number
          unique_spots: number
          user: string
          xp_to_next_level: number
          xp_to_next_level_progress: number
        }
        Insert: {
          legendary_spots?: number
          level?: number
          spotting_streak?: number
          total_spots?: number
          total_xp?: number
          unique_spots?: number
          user: string
          xp_to_next_level?: number
          xp_to_next_level_progress?: number
        }
        Update: {
          legendary_spots?: number
          level?: number
          spotting_streak?: number
          total_spots?: number
          total_xp?: number
          unique_spots?: number
          user?: string
          xp_to_next_level?: number
          xp_to_next_level_progress?: number
        }
        Relationships: [
          {
            foreignKeyName: "user_xp_stats_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "user_xp_stats_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_xp_stats_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_xp_stats_user_fkey"
            columns: ["user"]
            isOneToOne: true
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      users: {
        Row: {
          address: string | null
          banner_url: string | null
          country: string | null
          country_code: string | null
          created_at: string
          dob: string | null
          email: string
          experience: string | null
          fcm_token: string | null
          first_name: string | null
          id: string
          is_garage_private: boolean
          knowledge_level: string | null
          last_name: string | null
          lat_lng: unknown
          location: Json | null
          measurement: Database["public"]["Enums"]["measurement"] | null
          profile_picture_url: string | null
          state: string | null
          username: string | null
        }
        Insert: {
          address?: string | null
          banner_url?: string | null
          country?: string | null
          country_code?: string | null
          created_at?: string
          dob?: string | null
          email: string
          experience?: string | null
          fcm_token?: string | null
          first_name?: string | null
          id?: string
          is_garage_private?: boolean
          knowledge_level?: string | null
          last_name?: string | null
          lat_lng?: unknown
          location?: Json | null
          measurement?: Database["public"]["Enums"]["measurement"] | null
          profile_picture_url?: string | null
          state?: string | null
          username?: string | null
        }
        Update: {
          address?: string | null
          banner_url?: string | null
          country?: string | null
          country_code?: string | null
          created_at?: string
          dob?: string | null
          email?: string
          experience?: string | null
          fcm_token?: string | null
          first_name?: string | null
          id?: string
          is_garage_private?: boolean
          knowledge_level?: string | null
          last_name?: string | null
          lat_lng?: unknown
          location?: Json | null
          measurement?: Database["public"]["Enums"]["measurement"] | null
          profile_picture_url?: string | null
          state?: string | null
          username?: string | null
        }
        Relationships: []
      }
      xp_events: {
        Row: {
          car_spot: string | null
          created_at: string
          delta: number
          id: string
          type: Database["public"]["Enums"]["xp_event_type"]
          user: string
        }
        Insert: {
          car_spot?: string | null
          created_at?: string
          delta: number
          id?: string
          type: Database["public"]["Enums"]["xp_event_type"]
          user: string
        }
        Update: {
          car_spot?: string | null
          created_at?: string
          delta?: number
          id?: string
          type?: Database["public"]["Enums"]["xp_event_type"]
          user?: string
        }
        Relationships: [
          {
            foreignKeyName: "xp_events_car_spot_fkey"
            columns: ["car_spot"]
            isOneToOne: false
            referencedRelation: "car_spots"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "xp_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "user_xp_stats_old"
            referencedColumns: ["user"]
          },
          {
            foreignKeyName: "xp_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "usernames"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "xp_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "users"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "xp_events_user_fkey"
            columns: ["user"]
            isOneToOne: false
            referencedRelation: "xp_leaderboard"
            referencedColumns: ["user"]
          },
        ]
      }
      xp_levels: {
        Row: {
          level: number
          xp_cumulative: number
          xp_required: number
        }
        Insert: {
          level: number
          xp_cumulative: number
          xp_required: number
        }
        Update: {
          level?: number
          xp_cumulative?: number
          xp_required?: number
        }
        Relationships: []
      }
    }
    Views: {
      emails: {
        Row: {
          email: string | null
        }
        Insert: {
          email?: string | null
        }
        Update: {
          email?: string | null
        }
        Relationships: []
      }
      user_xp_stats_old: {
        Row: {
          level: number | null
          total_xp: number | null
          user: string | null
          xp_to_next_level: number | null
          xp_to_next_level_progress: number | null
        }
        Relationships: []
      }
      usernames: {
        Row: {
          id: string | null
          username: string | null
        }
        Insert: {
          id?: string | null
          username?: string | null
        }
        Update: {
          id?: string | null
          username?: string | null
        }
        Relationships: []
      }
      xp_leaderboard: {
        Row: {
          country: string | null
          country_code: string | null
          first_name: string | null
          last_name: string | null
          lat_lng: unknown
          profile_picture_url: string | null
          rank: number | null
          state: string | null
          total_xp: number | null
          user: string | null
          username: string | null
        }
        Relationships: []
      }
    }
    Functions: {
      get_country_leaderboard: {
        Args: { p_country_code: string }
        Returns: {
          country: string | null
          country_code: string | null
          first_name: string | null
          last_name: string | null
          lat_lng: unknown
          profile_picture_url: string | null
          rank: number | null
          state: string | null
          total_xp: number | null
          user: string | null
          username: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "xp_leaderboard"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      get_country_rank: { Args: { p_user_id: string }; Returns: number }
      get_friends_leaderboard: {
        Args: { p_user_id: string }
        Returns: {
          country: string | null
          country_code: string | null
          first_name: string | null
          last_name: string | null
          lat_lng: unknown
          profile_picture_url: string | null
          rank: number | null
          state: string | null
          total_xp: number | null
          user: string | null
          username: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "xp_leaderboard"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      get_friends_rank: { Args: { p_user_id: string }; Returns: number }
      get_spot_counts: {
        Args: { p_tz?: string; p_user: string }
        Returns: {
          last_hour_spots: number
          todays_spots: number
          total_spots: number
        }[]
      }
      get_state_leaderboard: {
        Args: { p_country_code: string; p_state: string }
        Returns: {
          country: string | null
          country_code: string | null
          first_name: string | null
          last_name: string | null
          lat_lng: unknown
          profile_picture_url: string | null
          rank: number | null
          state: string | null
          total_xp: number | null
          user: string | null
          username: string | null
        }[]
        SetofOptions: {
          from: "*"
          to: "xp_leaderboard"
          isOneToOne: false
          isSetofReturn: true
        }
      }
      get_state_rank: { Args: { p_user_id: string }; Returns: number }
      show_limit: { Args: never; Returns: number }
      show_trgm: { Args: { "": string }; Returns: string[] }
    }
    Enums: {
      measurement: "metric" | "imperial"
      rarity: "common" | "uncommon" | "rare" | "epic" | "legendary" | "mythic"
      xp_event_type: "spot"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      measurement: ["metric", "imperial"],
      rarity: ["common", "uncommon", "rare", "epic", "legendary", "mythic"],
      xp_event_type: ["spot"],
    },
  },
} as const
