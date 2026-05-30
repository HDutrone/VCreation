import React from 'react';
import { TouchableOpacity, Text, View, StyleSheet, Linking, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/Colors';

const WA_NUMBER = '243810000000';
const WA_MSG = encodeURIComponent('Bonjour V Créations, je souhaite en savoir plus sur vos créations.');

async function openWhatsApp() {
  const url = `https://wa.me/${WA_NUMBER}?text=${WA_MSG}`;
  const canOpen = await Linking.canOpenURL(url).catch(() => false);
  if (canOpen) {
    Linking.openURL(url);
  } else {
    Alert.alert('WhatsApp', `Contactez-nous au +${WA_NUMBER}`);
  }
}

export function WhatsAppFab() {
  return (
    <TouchableOpacity style={styles.fab} onPress={openWhatsApp} activeOpacity={0.85}>
      <Ionicons name="chatbubble-ellipses" size={26} color="#fff" />
    </TouchableOpacity>
  );
}

export function WhatsAppBanner() {
  return (
    <TouchableOpacity style={styles.banner} onPress={openWhatsApp} activeOpacity={0.8}>
      <View style={styles.iconWrap}>
        <Ionicons name="chatbubble-ellipses" size={22} color={Colors.whatsapp} />
      </View>
      <View style={{ flex: 1, marginLeft: 14 }}>
        <Text style={styles.bannerTitle}>Contactez-nous sur WhatsApp</Text>
        <Text style={styles.bannerSub}>+243 810 000 000</Text>
      </View>
      <Ionicons name="chevron-forward" size={18} color={Colors.textMuted} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  fab: {
    position: 'absolute', bottom: 88, right: 20,
    width: 54, height: 54, borderRadius: 27,
    backgroundColor: Colors.whatsapp,
    alignItems: 'center', justifyContent: 'center',
    elevation: 6, shadowColor: '#000', shadowOffset: { width: 0, height: 3 }, shadowOpacity: 0.3, shadowRadius: 6,
  },
  banner: {
    flexDirection: 'row', alignItems: 'center',
    backgroundColor: Colors.surface, borderRadius: 16,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 16, marginHorizontal: 20,
  },
  iconWrap: {
    width: 42, height: 42, borderRadius: 21,
    backgroundColor: Colors.whatsapp + '26',
    alignItems: 'center', justifyContent: 'center',
  },
  bannerTitle: { color: Colors.white, fontSize: 14, fontWeight: '600' },
  bannerSub: { color: Colors.textSecondary, fontSize: 12, marginTop: 2 },
});
