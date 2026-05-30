import React, { useState } from 'react';
import {
  View, Text, ScrollView, TextInput, TouchableOpacity,
  StyleSheet, Alert,
} from 'react-native';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider, SectionLabel } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { CustomRequest } from '../../types';

const GARMENTS = ['Robe de soirée', 'Kaftan', 'Tailleur', 'Ensemble'];
const OCCASIONS = ['Mariage', 'Gala', 'Corporate', 'Cérémonie', 'Autre'];
const DELAIS = ['1 mois', '2 mois', '3 mois', '6 mois', 'Flexible'];

function ChipGroup({ options, selected, onSelect }: { options: string[]; selected: string | null; onSelect: (v: string) => void }) {
  return (
    <View style={styles.chips}>
      {options.map(o => (
        <TouchableOpacity key={o} onPress={() => onSelect(o)} style={[styles.chip, selected === o && styles.chipActive]}>
          <Text style={[styles.chipText, selected === o && styles.chipTextActive]}>{o}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}

export default function SurMesureScreen() {
  const { state, addCustomRequest } = useApp();
  const [garment, setGarment] = useState<string | null>(null);
  const [occasion, setOccasion] = useState<string | null>(null);
  const [delai, setDelai] = useState<string | null>(null);
  const [message, setMessage] = useState('');
  const [loading, setLoading] = useState(false);

  const submit = async () => {
    if (!garment || !occasion || !delai) {
      Alert.alert('Champs requis', 'Veuillez compléter toutes les options.');
      return;
    }
    setLoading(true);
    await new Promise(r => setTimeout(r, 900));

    const req: CustomRequest = {
      id: `cr${Date.now()}`,
      clientName: state.user?.name ?? 'Client',
      garmentType: garment, occasion, delai,
      message: message.trim() || 'Pas de message supplémentaire.',
      receivedAt: 'à l\'instant',
      status: 'nouvelle',
    };
    addCustomRequest(req);
    setLoading(false);
    setGarment(null); setOccasion(null); setDelai(null); setMessage('');
    Alert.alert(
      '✓ Demande envoyée',
      'Notre atelier vous contactera dans les 24h pour affiner votre demande.',
      [{ text: 'Fermer' }]
    );
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content} keyboardShouldPersistTaps="handled">
      <Text style={styles.label}>L'ART DU</Text>
      <Text style={styles.title}>Sur-Mesure</Text>
      <View style={{ marginVertical: 16 }}><GoldDivider /></View>
      <Text style={styles.desc}>
        Chaque création naît d'un dialogue entre vous et notre atelier.{'\n'}
        Partagez votre vision, nous la sublimerons.
      </Text>
      <View style={{ height: 28 }} />

      <SectionLabel text="Type de tenue" />
      <View style={{ height: 10 }} />
      <ChipGroup options={GARMENTS} selected={garment} onSelect={setGarment} />
      <View style={{ height: 20 }} />

      <SectionLabel text="Occasion" />
      <View style={{ height: 10 }} />
      <ChipGroup options={OCCASIONS} selected={occasion} onSelect={setOccasion} />
      <View style={{ height: 20 }} />

      <SectionLabel text="Délai souhaité" />
      <View style={{ height: 10 }} />
      <ChipGroup options={DELAIS} selected={delai} onSelect={setDelai} />
      <View style={{ height: 20 }} />

      <SectionLabel text="Message personnalisé" />
      <View style={{ height: 10 }} />
      <TextInput
        style={styles.textarea}
        placeholder="Décrivez votre vision, vos inspirations..."
        placeholderTextColor={Colors.textMuted}
        multiline numberOfLines={5}
        value={message} onChangeText={setMessage}
        textAlignVertical="top"
      />
      <View style={{ height: 28 }} />
      <GoldButton label="Demander une consultation" onPress={submit} loading={loading} />
      <View style={{ height: 40 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  content: { padding: 20, paddingTop: 52 },
  label: { color: Colors.textMuted, fontSize: 12, letterSpacing: 3 },
  title: { color: Colors.white, fontSize: 40, fontWeight: '700', marginTop: 4 },
  desc: { color: Colors.textSecondary, fontSize: 14, lineHeight: 22 },
  chips: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  chip: {
    paddingHorizontal: 16, paddingVertical: 9, borderRadius: 20,
    borderWidth: 1, borderColor: Colors.cardBorder,
  },
  chipActive: { backgroundColor: Colors.goldFaint, borderColor: Colors.gold, borderWidth: 1.5 },
  chipText: { color: Colors.textSecondary, fontSize: 13 },
  chipTextActive: { color: Colors.gold, fontWeight: '600' },
  textarea: {
    backgroundColor: Colors.surface, borderRadius: 12,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 14, color: Colors.white, fontSize: 14,
    minHeight: 120,
  },
});
