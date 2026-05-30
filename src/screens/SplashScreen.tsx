import React, { useEffect, useRef } from 'react';
import { View, Text, TouchableOpacity, Animated, StyleSheet, Dimensions } from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Colors } from '../constants/Colors';
import { Logo } from '../components/Logo';
import type { RootStackParamList } from '../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Splash'>;
const { height } = Dimensions.get('window');

export default function SplashScreen({ navigation }: Props) {
  const logoOpacity   = useRef(new Animated.Value(0)).current;
  const logoScale     = useRef(new Animated.Value(0.85)).current;
  const entrerOpacity = useRef(new Animated.Value(0)).current;
  const lineHeight    = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.sequence([
      Animated.parallel([
        Animated.timing(logoOpacity, { toValue: 1, duration: 1000, useNativeDriver: true }),
        Animated.spring(logoScale, { toValue: 1, friction: 6, useNativeDriver: true }),
      ]),
      Animated.delay(300),
      Animated.parallel([
        Animated.timing(entrerOpacity, { toValue: 1, duration: 700, useNativeDriver: false }),
        Animated.timing(lineHeight, { toValue: 40, duration: 700, useNativeDriver: false }),
      ]),
    ]).start();
  }, []);

  const enter = () =>
    navigation.replace('ClientApp', { initialTab: 0 });

  return (
    <View style={styles.container}>
      {/* Radial glow */}
      <View style={styles.glow} />

      {/* Logo */}
      <Animated.View style={{ opacity: logoOpacity, transform: [{ scale: logoScale }] }}>
        <Logo size={130} />
      </Animated.View>

      {/* ENTRER section */}
      <Animated.View style={[styles.entrer, { opacity: entrerOpacity }]}>
        <TouchableOpacity onPress={enter} activeOpacity={0.7} style={styles.entrerTouch}>
          <Animated.View style={[styles.lineAbove, { height: lineHeight }]} />
          <Text style={styles.entrerText}>E N T R E R</Text>
          <View style={styles.lineBelow} />
        </TouchableOpacity>
      </Animated.View>

      {/* Hidden login access (long press top-right) */}
      <TouchableOpacity
        style={styles.hiddenLogin}
        onLongPress={() => navigation.navigate('Login')}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1, backgroundColor: Colors.background,
    alignItems: 'center', justifyContent: 'center',
  },
  glow: {
    position: 'absolute', width: 300, height: 300, borderRadius: 150,
    backgroundColor: Colors.gold, opacity: 0.04,
  },
  entrer: {
    position: 'absolute', bottom: 72, alignItems: 'center',
  },
  entrerTouch: { alignItems: 'center' },
  lineAbove: { width: 1, backgroundColor: Colors.textMuted },
  entrerText: {
    color: 'rgba(255,255,255,0.65)', fontSize: 12,
    letterSpacing: 6, fontWeight: '300', marginVertical: 14,
  },
  lineBelow: { width: 1, height: 40, backgroundColor: Colors.textMuted },
  hiddenLogin: { position: 'absolute', top: 40, right: 0, width: 60, height: 60 },
});
