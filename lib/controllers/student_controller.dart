import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:egresso_ifpi/domain/model/aluno.dart';
import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:egresso_ifpi/domain/model/matricula.dart';
import 'package:egresso_ifpi/domain/model/pessoa.dart';
import 'package:egresso_ifpi/domain/model/usuario.dart';
import 'package:egresso_ifpi/domain/service/auth_service.dart';
import 'package:egresso_ifpi/utils/constantes.dart';
import 'package:egresso_ifpi/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
part 'student_controller.g.dart';

class StudentController = _StudentControllerBase with _$StudentController;

abstract class _StudentControllerBase with Store {
  final authService = AuthService();
  final utilsController = GetIt.I.get<Utils>();

  @observable
  bool loading = false;

  @observable
  bool newStudent;

  @observable
  Usuario user = Usuario();
  @observable
  PessoaModel person = PessoaModel();
  @observable
  StudentModel student = StudentModel();
  @observable
  ObservableList<dynamic> matriculas = ObservableList().asObservable();

  _StudentControllerBase(this.newStudent);

  saveMatriculas() async {
    for (MatriculaModel matricula in matriculas) {
      if (matricula.uid != null)
        await updateMatricula(matricula);
      else
        await saveNewMatricula(matricula);
    }
  }

  saveNewMatricula(MatriculaModel m) async {
    m.setAlunoUid(student.uid);
    m.setDataCadastro(Timestamp.now());
    await FirebaseFirestore.instance.collection('matricula').add(m.toMap());
  }

  updateMatricula(MatriculaModel m) async {
    if (m.status != 'em_andamento' && m.dataFim == null) {
      m.setDataFim(Timestamp.now());

      await FirebaseFirestore.instance
          .collection('matricula')
          .doc(m.uid)
          .update(m.toMap());
    } else if (m.status == 'em_andamento' && m.dataFim != null) {
      m.setDataFim(null);

      await FirebaseFirestore.instance
          .collection('matricula')
          .doc(m.uid)
          .update(m.toMap());
    }
  }

  isValidMatricula(String matricula) {
    for (MatriculaModel m in matriculas) {
      if (m.matricula == matricula) {
        return false;
      }
    }
    return true;
  }

  isValidMail() async {
    final item = await FirebaseFirestore.instance
        .collection('pessoa')
        .where('email', isEqualTo: person.email)
        .get();
    if (item.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  isValidCPF() async {
    final item = await FirebaseFirestore.instance
        .collection('pessoa')
        .where('cpf', isEqualTo: person.cpf)
        .get();
    if (item.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  saveStudent() async {
    student.setDataCadastro(Timestamp.now());
    await FirebaseFirestore.instance
        .collection('aluno')
        .add(student.toMap())
        .then((value) => student.setUid(value.id));
  }

  updateStudent() async {
    await FirebaseFirestore.instance
        .collection('aluno')
        .doc(student.uid)
        .update(student.toMap());
  }

  updatePerson() async {
    await FirebaseFirestore.instance
        .collection('pessoa')
        .doc(person.uid)
        .update(person.toMap());
  }

  savePerson() async {
    person.setDataCadastro(Timestamp.now());
    await FirebaseFirestore.instance
        .collection('pessoa')
        .add(person.toMap())
        .then((value) {
      student.setPessoaUid(value.id);
      person.setUid(value.id);
    });
  }

  saveUser() async {
    user.setTipoUsuario(Constantes.typeStudent);
    user.setPessoaUid(person.uid);
    await FirebaseFirestore.instance.collection('usuario').add(user.toMap());
  }

  save(Function mensagem, Function fecharPagina) async {
    try {
      utilsController.iniciarLoding();

      if (!await isValidCPF()) {
        mensagem('CPF já se encontra cadastrado.');
      } else if (!await isValidMail()) {
        mensagem('EMAIL já se encontra cadastrado.');
      } else {
        if (student.uid != null) {
          await updateStudent();
          await updatePerson();
        } else {
          await savePerson();
          await saveUser();
          await saveStudent();
        }

        await saveMatriculas();

        utilsController.encerrarLoading();
        mensagem(Constantes.messageSuccess);
        fecharPagina();
      }
      utilsController.encerrarLoading();
    } catch (e) {
      utilsController.encerrarLoading();
      mensagem(Constantes.messageError);
      print('Ocorreu um erro $e');
    }
  }

  addMatriculaStudent(MatriculaModel matricula) async {
    matricula.setStatus('em_andamento');
    await getCurso(matricula);
    matriculas.add(matricula);
  }

  getCurso(MatriculaModel matricula) async {
    await FirebaseFirestore.instance
        .collection('curso')
        .doc(matricula.cursoUid)
        .get()
        .then((value) {
      final curso = CursoModel.fromDocument(value);
      matricula.curso = curso;
    });
  }

  getMatriculas() async {
    await FirebaseFirestore.instance
        .collection('matricula')
        .where('aluno_uid', isEqualTo: student.uid)
        // .orderBy('data_inicio', descending: true)
        .get()
        .then((value) {
      value.docs.map((matricula) {
        final m = MatriculaModel.fromDocument(matricula);
        matriculas.add(m);
        getCurso(m);
      }).toList();
    });
  }

  isMatriculaInProgress() {
    for (MatriculaModel m in matriculas) {
      if (m.status == 'em_andamento') {
        return true;
      }
    }
    return false;
  }

  getDataStudent(String personUid) async {
    await getPerson(personUid);
    await getStudent();
    await getMatriculas();
  }

  getPerson(personUid) async {
    await FirebaseFirestore.instance
        .collection('pessoa')
        .doc(personUid)
        .get()
        .then((value) => person = PessoaModel.fromDocument(value));
  }

  getStudent() async {
    await FirebaseFirestore.instance
        .collection('aluno')
        .where('pessoa_uid', isEqualTo: person.uid)
        .get()
        .then((value) => student = StudentModel.fromDocument(value.docs[0]));
  }
}
