import React from 'react';
import { TouchableOpacity, Text, StyleSheet, ActivityIndicator, ViewStyle } from 'react-native';
import { Colors } from '../constants/Colors';

interface GoldButtonProps {
  label: string;
  onPress?: () => void;
  outlined?: boolean;
  loading?: boolean;
  style?: ViewStyle;
  disabled?: boolean;
}

export function GoldButton({ label, onPress, outlined = false, loading = false, style, disabled }: GoldButtonProps) {
  return (
    <TouchableOpacity
      onPress={onPress}
      disabled={loading || disabled}
      activeOpacity={0.8}
      style={[
        styles.btn,
        outlined ? styles.outlined : styles.filled,
        (loading || disabled) && { opacity: 0.6 },
        style,
      ]}
    >
      {loading
        ? <ActivityIndicator color={outlined ? Colors.gold : Colors.background} size="small" />
        : <Text style={[styles.label, { color: outlined ? Colors.gold : Colors.background }]}>
            {label.toUpperCase()}
          </Text>
      }
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  btn: {
    height: 54,
    borderRadius: 27,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 24,
  },
  filled: { backgroundColor: Colors.gold },
  outlined: { borderWidth: 1.5, borderColor: Colors.gold, backgroundColor: 'transparent' },
  label: { fontSize: 13, fontWeight: '700', letterSpacing: 2 },
});
