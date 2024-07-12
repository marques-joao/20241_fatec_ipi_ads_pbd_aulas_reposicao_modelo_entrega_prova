-- ----------------------------------------------------------------
-- 1 Base de dados e criação de tabela
--escreva a sua solução aqui

CREATE TABLE student_prediction (
    studentID VARCHAR(200),
    age INT,
    gender INT,
    hs_type INT,
    scholarship INT,
    work INT,
    activity INT,
    partner INT,
    salary INT,
    transport INT,
    living INT,
    mother_edu INT,
    father_edu INT,
    siblings INT,
    kids INT,
    mother_job INT,
    father_job INT,
    study_hrs INT,
    read_freq INT,
    read_freq_sci INT,
    attend_dept INT,
    impact INT,
    attend INT,
    prep_study INT,
    prep_exam INT,
    notes INT,
    listens INT,
    likes_discuss INT,
    classroom INT,
    cuml_gpa INT,
    exp_gpa INT,
    course_id INT,
    grade INT
);

-- ----------------------------------------------------------------
-- 2 Resultado em função da formação dos pais
--escreva a sua solução aqui

DO $$
    DECLARE
        cur_alunos_aprovados_pai_phd REFCURSOR;
        v_alunos INT;
    BEGIN
        OPEN cur_alunos_aprovados_pai_phd FOR 
        SELECT count(studentid) FROM student_prediction WHERE grade > 0 AND (mother_edu=6 OR father_edu=6);

    LOOP 
        FETCH cur_alunos_aprovados_pai_phd INTO v_alunos;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE '%', v_alunos;
    END LOOP;

    CLOSE cur_alunos_aprovados_pai_phd;

END;$$

-- ----------------------------------------------------------------
-- 3 Resultado em função dos estudos
--escreva a sua solução aqui

DO $$
    DECLARE
        -- 1. Declaração
        cur_alunos_aprovados_sozinho REFCURSOR;
        v_alunos INT;
        v_nome_tabela VARCHAR(200) := 'student_prediction';
    BEGIN
        -- 2. Abertura
        OPEN cur_alunos_aprovados_sozinho FOR EXECUTE 
        format(
            '
                SELECT count(studentid) FROM %s WHERE grade > 0 AND prep_study = 1 
            ',
            v_nome_tabela
        ) USING v_alunos;

        LOOP
            -- 3. Recuperação
            FETCH cur_alunos_aprovados_sozinho INTO v_alunos;
            EXIT WHEN NOT FOUND;

            IF v_alunos IS NULL THEN
                RAISE NOTICE '-1';
            END IF;

            RAISE NOTICE '%', v_alunos;
        END LOOP;

        -- 4. Fechamento do cursor
        CLOSE cur_alunos_aprovados_sozinho;
END;$$

-- ----------------------------------------------------------------
-- 4 Salário versus estudos
--escreva a sua solução aqui

DO $$
    DECLARE
        -- 1. Declaração
        cur_aluno_salario_estudos CURSOR FOR 
        SELECT count(studentid) FROM student_prediction WHERE prep_exam = 2 AND salary = 5;
        v_alunos INT;
    BEGIN
        -- 2. Abertura
        OPEN cur_aluno_salario_estudos;

        LOOP
            -- 3. Recuperação
            FETCH cur_aluno_salario_estudos INTO v_alunos;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE '%', v_alunos;
        END LOOP;

        -- 4. Fechamento do cursor
        CLOSE cur_aluno_salario_estudos;
END;$$

-- ----------------------------------------------------------------
-- 5. Limpeza de valores NULL
--escreva a sua solução aqui

DO $$
    DECLARE
        -- não vinculado
        cur_nulos REFCURSOR;
        v_tupla RECORD;
    BEGIN
        -- 2. Abertura do cursor
        OPEN cur_nulos SCROLL FOR 
        SELECT * FROM student_prediction;

        LOOP
            -- 3. Recuperação dos dados
            FETCH cur_nulos INTO v_tupla;
            EXIT WHEN NOT FOUND;
            
            IF v_tupla IS NULL THEN
                DELETE FROM student_prediction WHERE CURRENT OF cur_nulos;
            END IF;

        END LOOP;

        LOOP
            FETCH BACKWARD FROM cur_nulos INTO v_tupla;
            EXIT WHEN NOT FOUND;
            RAISE NOTICE '%', v_tupla;
        END LOOP;

    CLOSE cur_nulos;

END;$$

-- ----------------------------------------------------------------