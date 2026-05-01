import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider } from '../../components/GoldDivider';
import type { RootStackParamList } from '../../navigation/types';

type Props = NativeStackScreenProps<RootStackParamList, 'Confirmation'>;

export default function ConfirmationScreen({ route, navigation }: Props) {
  const { orderId } = route.params;

  return (
    <View style={styles.container}>
      <View style={styles.card}>
        <View style={styles.iconWrap}>
          <Ionicons name="checkmark-circle" size={64} color={Colors.gold} />
        </View>
        <Text style={styles.title}>Commande confirmée</Text>
        <View style={{ marginVertical: 16 }}><GoldDivider /></View>
        <Text style={styles.ref}>Référence</Text>
        <Text style={styles.refId}>{orderId}</Text>
        <View style={{ height: 20 }} />
        <Text style={styles.desc}>
          Votre commande a été reçue avec succès.{'\n'}
          Notre équipe vous contactera dans les 24h pour confirmer les détails de livraison.
        </Text>
        <View style={{ height: 32 }} />
        <GoldButton
          label="Suivre ma commande"
          onPress={() => navigation.navigate('Tracking', { orderId })}
        />
        <View style={{ height: 12 }} />
        <TouchableOpacity
          onPress={() => navigation.navigate('ClientApp', { initialTab: 0 })}
          style={styles.homeBtn}
        >
          <Text style={styles.homeBtnText}>Retour à l'accueil</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1, backgroundColor: Colors.background,
    alignItems: 'center', justifyContent: 'center', padding: 24,
  },
  card: {
    backgroundColor: Colors.surface, borderRadius: 20,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 28, width: '100%', alignItems: 'center',
  },
  iconWrap: {
    width: 96, height: 96, borderRadius: 48,
    backgroundColor: Colors.goldFaint,
    alignItems: 'center', justifyContent: 'center', marginBottom: 20,
  },
  title: { color: Colors.white, fontSize: 24, fontWeight: '700' },
  ref: { color: Colors.textMuted, fontSize: 12, letterSpacing: 2 },
  refId: { color: Colors.gold, fontSize: 18, fontWeight: '700', marginTop: 4 },
  desc: { color: Colors.textSecondary, fontSize: 14, lineHeight: 22, textAlign: 'center' },
  homeBtn: { paddingVertical: 10 },
  homeBtnText: { color: Colors.textSecondary, fontSize: 14 },
});
