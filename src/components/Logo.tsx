import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '../constants/Colors';

interface LogoProps {
  size?: number;
  darkBg?: boolean;
  showSubtitle?: boolean;
}

export function Logo({ size = 120, darkBg = true, showSubtitle = true }: LogoProps) {
  const vColor = darkBg ? Colors.white : '#000000';
  return (
    <View style={styles.container}>
      {/* V + dress silhouette */}
      <View style={{ width: size, height: size * 0.85, alignItems: 'center' }}>
        <Text style={[styles.vLetter, { fontSize: size * 0.82, color: vColor }]}>V</Text>
        {/* Gold dress overlay */}
        <View style={[styles.dress, {
          width: size * 0.28,
          height: size * 0.52,
          bottom: 0,
          borderTopLeftRadius: size * 0.04,
          borderTopRightRadius: size * 0.04,
          borderBottomLeftRadius: size * 0.15,
          borderBottomRightRadius: size * 0.15,
        }]} />
        {/* Hanger dot */}
        <View style={[styles.dot, { width: size * 0.06, height: size * 0.06, top: size * 0.01 }]} />
      </View>
      <Text style={[styles.creations, { fontSize: size * 0.26 }]}>Créations</Text>
      {showSubtitle && (
        <Text style={[styles.subtitle, { fontSize: size * 0.10, color: darkBg ? Colors.textSecondary : '#555' }]}>
          Haute-couture
        </Text>
      )}
    </View>
  );
}

export function LogoSmall({ height = 36 }: { height?: number }) {
  return (
    <View style={styles.smallRow}>
      <View style={{ width: height * 0.65, height, alignItems: 'center' }}>
        <Text style={[styles.vLetter, { fontSize: height * 0.85, color: Colors.white, lineHeight: height }]}>V</Text>
        <View style={[styles.dress, {
          width: height * 0.22, height: height * 0.42,
          bottom: 0,
          borderTopLeftRadius: 2, borderTopRightRadius: 2,
          borderBottomLeftRadius: height * 0.08, borderBottomRightRadius: height * 0.08,
        }]} />
      </View>
      <View style={{ marginLeft: 6 }}>
        <Text style={[styles.creations, { fontSize: height * 0.32 }]}>Créations</Text>
        <Text style={[styles.subtitle, { fontSize: height * 0.14 }]}>Haute-couture</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { alignItems: 'center' },
  vLetter: {
    fontWeight: '900',
    lineHeight: undefined,
    position: 'absolute',
    top: 0,
  },
  dress: {
    position: 'absolute',
    backgroundColor: Colors.gold,
  },
  dot: {
    position: 'absolute',
    backgroundColor: Colors.gold,
    borderRadius: 999,
    left: '50%',
    marginLeft: -3,
  },
  creations: {
    color: Colors.gold,
    fontStyle: 'italic',
    fontWeight: '700',
    marginTop: 4,
    letterSpacing: 1,
  },
  subtitle: {
    color: Colors.textSecondary,
    letterSpacing: 3,
    fontWeight: '300',
    marginTop: 2,
  },
  smallRow: { flexDirection: 'row', alignItems: 'center' },
});
