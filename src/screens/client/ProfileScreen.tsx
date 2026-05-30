import React from 'react';
import {
  View, Text, ScrollView, TouchableOpacity, StyleSheet, Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Colors } from '../../constants/Colors';
import { GoldButton } from '../../components/GoldButton';
import { GoldDivider } from '../../components/GoldDivider';
import { useApp } from '../../context/AppContext';
import type { RootStackParamList } from '../../navigation/types';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function ProfileScreen() {
  const navigation = useNavigation<Nav>();
  const { state, logout } = useApp();
  const user = state.user;

  const handleLogout = () => {
    Alert.alert('Déconnexion', 'Voulez-vous vraiment vous déconnecter ?', [
      { text: 'Annuler', style: 'cancel' },
      { text: 'Se déconnecter', style: 'destructive', onPress: () => { logout(); navigation.navigate('Login'); } },
    ]);
  };

  if (!user) {
    return (
      <View style={styles.guest}>
        <Ionicons name="person-circle-outline" size={80} color={Colors.textMuted} />
        <Text style={styles.guestTitle}>Connectez-vous</Text>
        <Text style={styles.guestDesc}>Créez un compte pour accéder à toutes les fonctionnalités.</Text>
        <View style={{ height: 24 }} />
        <GoldButton label="Se connecter" onPress={() => navigation.navigate('Login')} />
        <View style={{ height: 12 }} />
        <TouchableOpacity onPress={() => navigation.navigate('Register')}>
          <Text style={styles.registerLink}>Créer un compte</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Avatar */}
      <View style={styles.avatarSection}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{user.name[0].toUpperCase()}</Text>
        </View>
        <Text style={styles.name}>{user.name}</Text>
        <Text style={styles.email}>{user.email}</Text>
        <View style={styles.roleBadge}>
          <Text style={styles.roleText}>{user.role === 'admin' ? 'Administrateur' : 'Client'}</Text>
        </View>
      </View>

      <View style={{ marginVertical: 20 }}><GoldDivider /></View>

      {/* Stats */}
      <View style={styles.stats}>
        <StatCard label="Commandes" value={String(state.orders.length)} icon="bag-outline" />
        <StatCard label="Favoris" value={String(state.products.filter(p => p.isFavorite).length)} icon="heart-outline" />
        <StatCard label="Panier" value={String(state.cart.length)} icon="cart-outline" />
      </View>

      <View style={{ height: 24 }} />

      {/* Menu */}
      <MenuItem icon="receipt-outline" label="Mes commandes" onPress={() => navigation.navigate('Orders')} />
      <MenuItem icon="heart-outline" label="Mes favoris" onPress={() => navigation.navigate('Favorites')} />
      <MenuItem icon="cut-outline" label="Sur-mesure" onPress={() => navigation.navigate('ClientApp', { initialTab: 2 })} />

      <View style={{ height: 20 }} />
      <View style={styles.divider} />
      <View style={{ height: 20 }} />

      <MenuItem icon="help-circle-outline" label="Aide & support" onPress={() => {}} />
      <MenuItem icon="shield-checkmark-outline" label="Confidentialité" onPress={() => {}} />

      <View style={{ height: 28 }} />
      <GoldButton label="Se déconnecter" onPress={handleLogout} outlined />
      <View style={{ height: 60 }} />
    </ScrollView>
  );
}

function StatCard({ label, value, icon }: { label: string; value: string; icon: any }) {
  return (
    <View style={styles.statCard}>
      <Ionicons name={icon} size={20} color={Colors.gold} />
      <Text style={styles.statValue}>{value}</Text>
      <Text style={styles.statLabel}>{label}</Text>
    </View>
  );
}

function MenuItem({ icon, label, onPress }: { icon: any; label: string; onPress: () => void }) {
  return (
    <TouchableOpacity style={styles.menuItem} onPress={onPress}>
      <View style={styles.menuIcon}>
        <Ionicons name={icon} size={20} color={Colors.textSecondary} />
      </View>
      <Text style={styles.menuLabel}>{label}</Text>
      <Ionicons name="chevron-forward" size={16} color={Colors.textMuted} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.background },
  content: { padding: 20, paddingTop: 52 },
  guest: {
    flex: 1, backgroundColor: Colors.background,
    alignItems: 'center', justifyContent: 'center', padding: 40,
  },
  guestTitle: { color: Colors.white, fontSize: 22, fontWeight: '700', marginTop: 16 },
  guestDesc: { color: Colors.textSecondary, fontSize: 14, textAlign: 'center', marginTop: 8, lineHeight: 22 },
  registerLink: { color: Colors.gold, fontSize: 14 },
  avatarSection: { alignItems: 'center' },
  avatar: {
    width: 80, height: 80, borderRadius: 40,
    backgroundColor: Colors.goldFaint, borderWidth: 2, borderColor: Colors.gold,
    alignItems: 'center', justifyContent: 'center', marginBottom: 12,
  },
  avatarText: { color: Colors.gold, fontSize: 32, fontWeight: '700' },
  name: { color: Colors.white, fontSize: 22, fontWeight: '700' },
  email: { color: Colors.textMuted, fontSize: 13, marginTop: 4 },
  roleBadge: {
    marginTop: 10, paddingHorizontal: 14, paddingVertical: 5,
    borderRadius: 20, borderWidth: 1, borderColor: Colors.gold + '66',
    backgroundColor: Colors.goldFaint,
  },
  roleText: { color: Colors.gold, fontSize: 12 },
  stats: { flexDirection: 'row', gap: 12 },
  statCard: {
    flex: 1, backgroundColor: Colors.surface, borderRadius: 14,
    borderWidth: 1, borderColor: Colors.cardBorder,
    padding: 14, alignItems: 'center', gap: 6,
  },
  statValue: { color: Colors.white, fontSize: 20, fontWeight: '700' },
  statLabel: { color: Colors.textMuted, fontSize: 11 },
  menuItem: {
    flexDirection: 'row', alignItems: 'center',
    paddingVertical: 16, gap: 14,
  },
  menuIcon: { width: 32, alignItems: 'center' },
  menuLabel: { flex: 1, color: Colors.white, fontSize: 15 },
  divider: { height: 1, backgroundColor: Colors.divider },
});
