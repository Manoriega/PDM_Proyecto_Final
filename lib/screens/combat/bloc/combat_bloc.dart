import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/Trainer.dart';
import 'package:pokimon/classes/item.dart';
import '../utils/utils.dart';

part 'combat_event.dart';
part 'combat_state.dart';

final _random = Random();

int randInRange(int min, int max) => min + _random.nextInt(max - min);

class CombatBloc extends Bloc<CombatEvent, CombatState> {
  CombatBloc() : super(CombatInitial()) {
    on<CombatEvent>((event, emit) {
      emit(PlayerTurnState());
    });
    on<PlayerChangePokemonEvent>((event, emit) {
      emit(PlayerChangePokemonState(event.pokemonActive));
      emit(EnemyTurnState());
    });
    on<PlayerAttackEvent>(((event, emit) {
      bool attackHit = attackLands(event.player.active, event.attack);
      if (attackHit) {
        int damage =
            getDamage(event.player.active, event.attack, event.enemy.active);
        String attackName = event.attack == 0
            ? event.player.active.firstAttack.name
            : event.player.active.secondAttack.name;
        String msg = "${event.player.active.name} used $attackName";
        emit(PlayerAttackSuccedState(msg));
        if (event.enemy.active.currentHP - damage <= 0) {
          event.enemy.active.currentHP = 0;
          if (trainerHasPokemon(event.enemy.team)) {
            emit(EnemyActivePokemonDiesState());
            emit(WaitingState(
                "The foe pokemon can't continue with the combat", 1));
          } else {
            emit(PlayerWinState(
                "${event.enemy.name} can't continue with the combat.\n${event.player.name} is the winner"));
          }
        } else {
          event.enemy.active.currentHP -= damage;
          emit(WaitingState(msg, 0));
        }
      } else {
        String msg = "${event.player.active.name} failed to attack";
        emit(PlayerAttackFailedState(msg));
        emit(WaitingState(msg, 0));
      }
    }));
    on<PlayerUseItemEvent>(((event, emit) {
      event.item.useItem(event.pokemon);
      String msg = "You used ${event.item.name}";
      event.player.backpack.remove(event.item);
      emit(PlayerUseItem(msg));
      emit(WaitingState(msg, 0));
    }));
    on<EnemyTurnEvent>(((event, emit) {
      switch (event.option) {
        case 0:
          int attack = getEnemyAttack();
          bool attackHit = attackLands(event.enemy.active, attack);
          if (attackHit) {
            int damage =
                getDamage(event.enemy.active, attack, event.player.active);
            if (event.player.active.currentHP - damage <= 0) {
              event.player.active.currentHP = 0;
              if (trainerHasPokemon(event.player.team)) {
                emit(PlayerActivePokemonDiesState());
              } else {
                emit(PlayerLooseState(
                    "${event.player.name} can't continue with the combat.\n${event.enemy.name} is the winner"));
              }
            } else {
              event.player.active.currentHP -= damage;
              String attackName = attack == 0
                  ? event.enemy.active.firstAttack.name
                  : event.enemy.active.secondAttack.name;
              emit(EnemyActionState(
                  "Foe ${event.enemy.active.name} used ${attackName}"));
              emit(WaitingState(
                  "Foe ${event.enemy.active.name} used ${attackName}", 1));
            }
          } else {
            String msg = "Foe ${event.enemy.active.name} failed to attack";
            emit(EnemyActionState(msg));
            emit(WaitingState(msg, 1));
          }
          break;
        case 1:
          int itemOpt = getItemOption(event.enemy.backpack);
          Item item = event.enemy.backpack[itemOpt];
          item.useItem(event.enemy.active);
          emit(EnemyActionState("${event.enemy.name} used ${item.name}"));
          emit(WaitingState("${event.enemy.name} used ${item.name}", 1));
          break;
        default:
      }
    }));
    on<SetPlayerTurnEvent>(((event, emit) {
      emit(PlayerTurnState());
    }));
  }

  attackLands(Pokemon activeP, int attack) {
    var moveAccuracy = attack == 0
        ? activeP.firstAttack.accuracy
        : activeP.secondAttack.accuracy;
    var mAccuracy = moveAccuracy / 100;
    var accuracy = mAccuracy * (getAccuracyVariation() / 100);
    return accuracy >= 1;
  }

  getDamage(Pokemon activeP, int attack, Pokemon passiveP) {
    var bonificacion = getBonification(activeP, attack);
    var efectividad = getEffective(activeP, attack, passiveP);
    var variacion = getVariation();
    var firstP = 0.01 * bonificacion * efectividad * variacion;
    var attackVal = getAttack(activeP, attack);
    var movePower = getMovePotential(activeP, attack);
    var deffenseVal = getDeffense(activeP, attack, passiveP);
    var dividend = ((0.2 * (activeP.level + 1)) * attackVal * movePower);
    var divided = dividend / (25 * deffenseVal);
    var secondP = divided + 2;
    var damage = (firstP * secondP);
    return damage.round();
  }

  int getEnemyAttack() {
    return randInRange(0, 2);
  }

  int getItemOption(List<Item> backpack) {
    return randInRange(0, backpack.length);
  }

  int getVariation() {
    return randInRange(85, 101);
  }

  getAttack(Pokemon activeP, int attack) {
    String category = attack == 0
        ? activeP.firstAttack.category
        : activeP.secondAttack.category;
    return category == "physical" ? activeP.attack : activeP.specialAttack;
  }

  getMovePotential(Pokemon activeP, int attack) {
    return attack == 0 ? activeP.firstAttack.power : activeP.secondAttack.power;
  }

  getDeffense(Pokemon activeP, int attack, Pokemon passiveP) {
    String category = attack == 0
        ? activeP.firstAttack.category
        : activeP.secondAttack.category;
    return category == "physical" ? passiveP.defense : passiveP.specialDefense;
  }

  getBonification(Pokemon activeP, int attack) {
    String moveType =
        attack == 0 ? activeP.firstAttack.type : activeP.secondAttack.type;
    return moveType == activeP.type ? 1.5 : 1.0;
  }

  getEffective(Pokemon activeP, int attack, Pokemon passiveP) {
    String moveType =
        attack == 0 ? activeP.firstAttack.type : activeP.secondAttack.type;
    return CombatUtils().getEffectiveness(moveType, passiveP.type);
  }

  getAccuracyVariation() {
    return randInRange(125, 201);
  }

  bool trainerHasPokemon(List<Pokemon> team) {
    for (var i = 0; i < team.length; i++) {
      if (team[i].currentHP > 0) {
        return true;
      }
    }
    return false;
  }
}
